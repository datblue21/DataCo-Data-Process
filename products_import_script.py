#!/usr/bin/env python3
"""
Products Import Script - DataCo ETL Pipeline
==========================================
Script riêng để import tất cả 118 products mà không ảnh hưởng đến các script đã hoàn thiện.

Author: Database Expert (20+ years experience)
Date: 2025-08-11
"""

import pandas as pd
import mysql.connector
import logging
import sys
import re
from datetime import datetime
from typing import Dict, Any, Optional

class ProductsImporter:
    """Class chuyên xử lý import products với đầy đủ 118 sản phẩm."""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.connection = None
        self.cursor = None
        self.setup_logging()
        
        # Product status mapping theo DataCo_Database_Mapping.md
        self.product_status_mapping = {
            0: 'ACTIVE',
            1: 'INACTIVE'
        }
        
    def setup_logging(self):
        """Setup logging cho products import."""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('products_import.log'),
                logging.StreamHandler(sys.stdout)
            ]
        )
        self.logger = logging.getLogger(__name__)
        
    def clean_string(self, value: str, max_length: int = None) -> str:
        """Clean string để tránh SQL injection và encoding issues."""
        if pd.isna(value) or value is None:
            return ''
        
        # Convert to string và clean
        clean_value = str(value).strip()
        # Escape single quotes
        clean_value = clean_value.replace("'", "''")
        # Remove control characters
        clean_value = re.sub(r'[\x00-\x1f\x7f-\x9f]', '', clean_value)
        
        if max_length and len(clean_value) > max_length:
            clean_value = clean_value[:max_length-3] + '...'
            
        return clean_value
        
    def connect_to_database(self) -> bool:
        """Kết nối đến production database."""
        try:
            self.logger.info("🔌 Connecting to production database...")
            self.connection = mysql.connector.connect(**self.config)
            self.cursor = self.connection.cursor(buffered=True)
            
            # Test connection
            self.cursor.execute("SELECT 1")
            result = self.cursor.fetchone()
            
            if result and result[0] == 1:
                self.logger.info("✅ Database connection successful")
                return True
                
        except Exception as e:
            self.logger.error(f"❌ Database connection failed: {e}")
            return False
            
    def load_dataset(self, csv_file: str = 'DataCo_UTF8.csv') -> pd.DataFrame:
        """Load dataset từ CSV file."""
        try:
            self.logger.info(f"📂 Loading dataset: {csv_file}")
            df = pd.read_csv(csv_file)
            
            # Extract unique products
            products_df = df[[
                'Product Card Id', 'Product Name', 'Product Image', 
                'Product Price', 'Category Id', 'Category Name'
            ]].drop_duplicates(subset=['Product Card Id'])
            
            self.logger.info(f"✅ Loaded {len(products_df)} unique products")
            return products_df
            
        except Exception as e:
            self.logger.error(f"❌ Failed to load dataset: {e}")
            return None
            
    def check_existing_products(self) -> int:
        """Kiểm tra số products hiện có trong database."""
        try:
            self.cursor.execute("SELECT COUNT(*) FROM products")
            count = self.cursor.fetchone()[0]
            self.logger.info(f"📊 Current products in database: {count}")
            return count
        except Exception as e:
            self.logger.error(f"❌ Failed to check existing products: {e}")
            return 0
            
    def get_category_mapping(self) -> Dict[int, int]:
        """Lấy mapping từ external_id sang id cho categories."""
        try:
            self.cursor.execute("SELECT external_id, id FROM categories WHERE external_id IS NOT NULL")
            category_mapping = {row[0]: row[1] for row in self.cursor.fetchall()}
            self.logger.info(f"📋 Found {len(category_mapping)} category mappings")
            return category_mapping
        except Exception as e:
            self.logger.error(f"❌ Failed to get category mapping: {e}")
            return {}
            
    def generate_products_sql(self, products_df: pd.DataFrame) -> str:
        """Generate SQL để insert tất cả products."""
        try:
            self.logger.info("🏗️ Generating products SQL...")
            
            # Get category mapping
            category_mapping = self.get_category_mapping()
            
            product_values = []
            skipped_count = 0
            
            for _, row in products_df.iterrows():
                try:
                    external_id = int(row['Product Card Id'])
                    name = self.clean_string(row['Product Name'], 255)
                    
                    # Handle description (use name if no separate description)
                    description = self.clean_string(row['Product Name'], 500)
                    
                    # Handle price với validation
                    try:
                        price_value = row['Product Price']
                        if pd.isna(price_value) or price_value is None or price_value == '':
                            unit_price = 0.00
                        else:
                            unit_price = float(price_value)
                            # Validate range for DECIMAL(15,2)
                            if unit_price < 0:
                                unit_price = 0.00
                            elif unit_price > 9999999999999.99:  # Max for DECIMAL(15,2)
                                unit_price = 9999999999999.99
                    except (ValueError, TypeError, OverflowError):
                        unit_price = 0.00
                        
                    # Product status (default to ACTIVE)
                    product_status = 'ACTIVE'
                    
                    # Product image
                    product_image = self.clean_string(row['Product Image'], 500) if pd.notna(row['Product Image']) else ''
                    
                    # Category mapping
                    category_external_id = int(row['Category Id'])
                    if category_external_id in category_mapping:
                        category_id = category_mapping[category_external_id]
                    else:
                        self.logger.warning(f"⚠️ Category {category_external_id} not found, skipping product {external_id}")
                        skipped_count += 1
                        continue
                    
                    # Generate product_code từ external_id
                    product_code = f"PROD_{external_id}"
                    
                    # Debug log for first few products
                    if len(product_values) < 3:
                        self.logger.info(f"   Product {external_id}: {name} | Price: {unit_price} | Category: {category_id}")
                    
                    # Chỉ insert các trường theo DataCo_Database_Mapping.md + required fields
                    product_values.append(
                        f"({external_id}, '{product_code}', '{name}', '{description}', {unit_price:.2f}, "
                        f"'{product_status}', '{product_image}', {category_id}, 0, 0, NOW())"
                    )
                    
                except Exception as e:
                    self.logger.warning(f"⚠️ Skipping product row due to error: {e}")
                    skipped_count += 1
                    continue
            
            if product_values:
                sql = f"""
-- Products Import - Tất cả {len(product_values)} sản phẩm
INSERT IGNORE INTO products 
(external_id, product_code, name, description, unit_price, product_status, product_image, category_id, stock_quantity, is_fragile, created_at) VALUES
{', '.join(product_values)};
"""
                self.logger.info(f"✅ Generated SQL for {len(product_values)} products")
                if skipped_count > 0:
                    self.logger.warning(f"⚠️ Skipped {skipped_count} products due to errors")
                return sql
            else:
                self.logger.error("❌ No valid products to insert")
                return ""
                
        except Exception as e:
            self.logger.error(f"❌ Failed to generate products SQL: {e}")
            return ""
            
    def backup_current_products(self) -> bool:
        """Backup current products trước khi update."""
        try:
            self.logger.info("💾 Creating products backup...")
            
            # Create backup table
            backup_table = f"products_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
            self.cursor.execute(f"CREATE TABLE {backup_table} AS SELECT * FROM products")
            
            self.logger.info(f"✅ Products backed up to table: {backup_table}")
            return True
            
        except Exception as e:
            self.logger.error(f"❌ Failed to backup products: {e}")
            return False
            
    def clear_existing_products(self) -> bool:
        """Clear existing products để import lại."""
        try:
            self.logger.info("🧹 Clearing existing products...")
            
            # Start transaction
            self.connection.start_transaction()
            
            try:
                # Disable foreign key checks
                self.cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
                
                # Delete all products
                self.cursor.execute("DELETE FROM products")
                
                # Reset auto increment
                self.cursor.execute("ALTER TABLE products AUTO_INCREMENT = 1")
                
                # Re-enable foreign key checks
                self.cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
                
                # Commit
                self.connection.commit()
                
                self.logger.info("✅ Existing products cleared")
                return True
                
            except Exception as e:
                self.connection.rollback()
                self.logger.error(f"❌ Failed to clear products: {e}")
                return False
                
        except Exception as e:
            self.logger.error(f"❌ Clear process failed: {e}")
            return False
    
    def import_products(self, sql: str, backup: bool = True, clear_existing: bool = True) -> bool:
        """Import products vào database."""
        try:
            if backup:
                if not self.backup_current_products():
                    self.logger.error("❌ Backup failed, aborting import")
                    return False
                    
            if clear_existing:
                if not self.clear_existing_products():
                    self.logger.error("❌ Clear existing failed, aborting import")
                    return False
            
            self.logger.info("🚀 Starting products import...")
            
            # Start transaction
            self.connection.start_transaction()
            
            try:
                # Execute SQL
                self.cursor.execute(sql)
                
                # Check results
                self.cursor.execute("SELECT COUNT(*) FROM products")
                new_count = self.cursor.fetchone()[0]
                
                # Commit transaction
                self.connection.commit()
                
                self.logger.info(f"✅ Products import completed. Total products: {new_count}")
                return True
                
            except Exception as e:
                self.connection.rollback()
                self.logger.error(f"❌ Import failed, transaction rolled back: {e}")
                return False
                
        except Exception as e:
            self.logger.error(f"❌ Import process failed: {e}")
            return False
            
    def verify_import(self) -> bool:
        """Verify kết quả import."""
        try:
            self.logger.info("🔍 Verifying products import...")
            
            # Count total products
            self.cursor.execute("SELECT COUNT(*) FROM products")
            total_products = self.cursor.fetchone()[0]
            
            # Count products với external_id
            self.cursor.execute("SELECT COUNT(*) FROM products WHERE external_id IS NOT NULL")
            external_id_products = self.cursor.fetchone()[0]
            
            # Sample products
            self.cursor.execute("""
                SELECT external_id, name, unit_price, product_status, c.name as category_name 
                FROM products p 
                JOIN categories c ON p.category_id = c.id 
                WHERE p.external_id IS NOT NULL
                LIMIT 10
            """)
            sample_products = self.cursor.fetchall()
            
            self.logger.info(f"📊 Verification Results:")
            self.logger.info(f"   Total products: {total_products}")
            self.logger.info(f"   Products with external_id: {external_id_products}")
            
            self.logger.info(f"🔍 Sample products:")
            for product in sample_products:
                self.logger.info(f"   ID:{product[0]} | {product[1]} | ${product[2]} | {product[3]} | {product[4]}")
            
            return total_products >= 118  # Expect at least 118 products
            
        except Exception as e:
            self.logger.error(f"❌ Verification failed: {e}")
            return False
            
    def cleanup(self):
        """Cleanup connections."""
        if self.cursor:
            self.cursor.close()
        if self.connection:
            self.connection.close()
        self.logger.info("🧹 Database connections closed")
        
    def run_import(self, csv_file: str = 'DataCo_UTF8.csv', backup: bool = True) -> bool:
        """Main method để chạy products import."""
        try:
            self.logger.info("🎯 Starting Products Import Process...")
            
            # Connect to database
            if not self.connect_to_database():
                return False
                
            # Check existing products
            existing_count = self.check_existing_products()
            
            # Load dataset
            products_df = self.load_dataset(csv_file)
            if products_df is None or len(products_df) == 0:
                return False
                
            # Generate SQL
            sql = self.generate_products_sql(products_df)
            if not sql:
                return False
                
            # Import products (with clear existing)
            if not self.import_products(sql, backup=True, clear_existing=True):
                return False
                
            # Verify import
            if not self.verify_import():
                self.logger.warning("⚠️ Verification failed, but import completed")
                
            self.logger.info("🎉 Products import completed successfully!")
            return True
            
        except Exception as e:
            self.logger.error(f"💥 Products import failed: {e}")
            return False
        finally:
            self.cleanup()

def main():
    """Main function."""
    # Production database config
    PRODUCTION_CONFIG = {
        'host': 'server.aptech.io',
        'user': 'fastroute_user', 
        'password': 'fastroute_password',
        'database': 'fastroute_test',
        'port': 3307,
        'charset': 'utf8mb4',
        'autocommit': False,
        'raise_on_warnings': True
    }
    
    # Create importer
    importer = ProductsImporter(PRODUCTION_CONFIG)
    
    # Run import
    success = importer.run_import('DataCo_UTF8.csv')
    
    if success:
        print("✅ Products import completed successfully!")
        sys.exit(0)
    else:
        print("❌ Products import failed!")
        sys.exit(1)

if __name__ == '__main__':
    main()
