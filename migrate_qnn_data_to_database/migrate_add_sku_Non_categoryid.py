#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script để thêm cột SKU vào bảng products và điền dữ liệu từ BackOrders_sku_only.csv
PHIÊN BẢN: Không có trường category_id
"""

import csv
import random
import mysql.connector
from datetime import datetime, timedelta
from decimal import Decimal

# Kết nối database
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'somethings',
    'database': 'fastroute'
}

def read_skus_from_csv(filename):
    """Đọc danh sách SKU từ file CSV"""
    skus = []
    with open(filename, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            skus.append(row['sku'])
    print(f"Đã đọc {len(skus)} SKU từ file {filename}")
    return skus

def get_existing_products(cursor):
    """Lấy danh sách ID các sản phẩm hiện có"""
    cursor.execute("SELECT id FROM products ORDER BY id")
    existing_ids = [row[0] for row in cursor.fetchall()]
    print(f"Có {len(existing_ids)} sản phẩm hiện có trong database")
    return existing_ids

def get_valid_ids(cursor):
    """Lấy danh sách các ID hợp lệ từ database (KHÔNG có category_id)"""
    # Lấy warehouse_id
    cursor.execute("SELECT id FROM warehouses ORDER BY id")
    warehouse_ids = [row[0] for row in cursor.fetchall()]
    
    # Lấy user_id (sample 500 users để random)
    cursor.execute("SELECT id FROM users ORDER BY RAND() LIMIT 500")
    user_ids = [row[0] for row in cursor.fetchall()]
    
    return {
        'warehouse_ids': warehouse_ids,
        'user_ids': user_ids
    }

def random_product_data(valid_ids):
    """Tạo dữ liệu ngẫu nhiên cho sản phẩm (KHÔNG có category_id)"""
    product_names = [
        "Smart watch", "Laptop", "Điện thoại", "Tai nghe", "Bàn phím",
        "Chuột", "Màn hình", "Máy tính bảng", "Camera", "Loa",
        "Áo thun", "Quần jean", "Giày thể thao", "Túi xách", "Ví",
        "Balo", "Mũ", "Kính mát", "Đồng hồ", "Vòng tay",
        "Sách", "Vở", "Bút", "Cặp sách", "Hộp bút"
    ]
    
    # Tạo tên sản phẩm có dấu tiếng Việt
    name = random.choice(product_names) + f" {random.randint(1, 999)}"
    description = name + " - Sản phẩm chất lượng cao"
    
    # Random các giá trị khác với foreign key hợp lệ (KHÔNG có category_id)
    unit_price = round(random.uniform(10, 2000), 2)
    weight = round(random.uniform(0.01, 50), 3)
    volume = round(random.uniform(0.001, 1), 3)
    is_fragile = random.choice([0, 1])
    stock_quantity = random.randint(0, 100)
    product_status = random.choice([1, 2])
    warehouse_id = random.choice(valid_ids['warehouse_ids'] + [None, None])  # Thêm None để có xác suất warehouse_id là NULL
    
    # Tạo thời gian ngẫu nhiên
    days_ago = random.randint(1, 365)
    created_at = datetime.now() - timedelta(days=days_ago)
    updated_at = created_at + timedelta(days=random.randint(0, days_ago))
    
    created_by = random.choice(valid_ids['user_ids'] + [None, None])  # Thêm None để có xác suất created_by là NULL
    notes = None if random.random() > 0.3 else "Ghi chú sản phẩm"
    
    return {
        'name': name,
        'description': description,
        'unit_price': unit_price,
        'weight': weight,
        'volume': volume,
        'is_fragile': is_fragile,
        'stock_quantity': stock_quantity,
        'product_status': product_status,
        'warehouse_id': warehouse_id,
        'created_at': created_at.strftime('%Y-%m-%d %H:%M:%S'),
        'updated_at': updated_at.strftime('%Y-%m-%d %H:%M:%S'),
        'created_by': created_by,
        'notes': notes
    }

def main():
    print("=" * 60)
    print("SCRIPT THÊM CỘT SKU VÀO BẢNG PRODUCTS")
    print("PHIÊN BẢN: Không có trường category_id")
    print("=" * 60)
    
    # 1. Đọc SKU từ file CSV
    print("\n[Bước 1] Đọc SKU từ file CSV...")
    skus = read_skus_from_csv('BackOrders_sku_only.csv')
    
    if len(skus) != 61589:
        print(f"CẢNH BÁO: File CSV có {len(skus)} SKU, không phải 61589!")
        response = input("Bạn có muốn tiếp tục? (y/n): ")
        if response.lower() != 'y':
            return
    
    # Kết nối database
    print("\n[Bước 2] Kết nối database...")
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    print("Đã kết nối thành công!")
    
    try:
        # 2. Thêm cột SKU (cho phép NULL tạm thời)
        print("\n[Bước 3] Thêm cột sku vào bảng products...")
        try:
            cursor.execute("""
                ALTER TABLE products 
                ADD COLUMN sku VARCHAR(50) NULL
            """)
            conn.commit()
            print("Đã thêm cột sku thành công!")
        except mysql.connector.Error as e:
            if "Duplicate column name" in str(e):
                print("Cột sku đã tồn tại, bỏ qua bước này.")
            else:
                raise
        
        # 3. Lấy danh sách sản phẩm hiện có
        print("\n[Bước 4] Lấy danh sách sản phẩm hiện có...")
        existing_ids = get_existing_products(cursor)
        existing_count = len(existing_ids)
        
        # 3.5. Lấy danh sách các ID hợp lệ
        print("\n[Bước 4.5] Lấy danh sách các ID hợp lệ cho foreign keys...")
        valid_ids = get_valid_ids(cursor)
        print(f"  - Có {len(valid_ids['warehouse_ids'])} warehouses")
        print(f"  - Có {len(valid_ids['user_ids'])} users (sample)")
        print(f"  - KHÔNG sử dụng category_id (bảng không có trường này)")
        
        # 4. Update SKU cho các sản phẩm hiện có
        print(f"\n[Bước 5] Update SKU cho {existing_count} sản phẩm hiện có...")
        for idx, product_id in enumerate(existing_ids):
            sku = skus[idx]
            cursor.execute(
                "UPDATE products SET sku = %s WHERE id = %s",
                (sku, product_id)
            )
            if (idx + 1) % 50 == 0:
                print(f"  Đã update {idx + 1}/{existing_count} sản phẩm...")
        conn.commit()
        print(f"Đã update SKU cho {existing_count} sản phẩm!")
        
        # 5. Insert các sản phẩm mới (KHÔNG có category_id)
        new_products_count = len(skus) - existing_count
        print(f"\n[Bước 6] Insert {new_products_count} sản phẩm mới...")
        
        insert_query = """
            INSERT INTO products 
            (name, description, unit_price, weight, volume, 
             is_fragile, stock_quantity, product_status, warehouse_id,
             created_at, updated_at, created_by, notes, sku)
            VALUES 
            (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        
        batch_size = 1000
        for i in range(existing_count, len(skus)):
            sku = skus[i]
            data = random_product_data(valid_ids)
            
            cursor.execute(insert_query, (
                data['name'],
                data['description'],
                data['unit_price'],
                data['weight'],
                data['volume'],
                data['is_fragile'],
                data['stock_quantity'],
                data['product_status'],
                data['warehouse_id'],
                data['created_at'],
                data['updated_at'],
                data['created_by'],
                data['notes'],
                sku
            ))
            
            # Commit theo batch để tăng hiệu suất
            if (i - existing_count + 1) % batch_size == 0:
                conn.commit()
                print(f"  Đã insert {i - existing_count + 1}/{new_products_count} sản phẩm...")
        
        conn.commit()
        print(f"Đã insert {new_products_count} sản phẩm mới!")
        
        # 6. Kiểm tra số lượng
        print("\n[Bước 7] Kiểm tra số lượng sản phẩm...")
        cursor.execute("SELECT COUNT(*) FROM products")
        total_count = cursor.fetchone()[0]
        print(f"Tổng số sản phẩm trong database: {total_count}")
        
        cursor.execute("SELECT COUNT(*) FROM products WHERE sku IS NOT NULL")
        sku_count = cursor.fetchone()[0]
        print(f"Số sản phẩm có SKU: {sku_count}")
        
        if total_count != 61589:
            print(f"CẢNH BÁO: Tổng số sản phẩm ({total_count}) khác 61589!")
        
        # 7. Set cột SKU là NOT NULL và UNIQUE
        print("\n[Bước 8] Set cột sku là NOT NULL và UNIQUE...")
        
        # Kiểm tra có giá trị NULL không
        cursor.execute("SELECT COUNT(*) FROM products WHERE sku IS NULL")
        null_count = cursor.fetchone()[0]
        
        if null_count > 0:
            print(f"CẢNH BÁO: Có {null_count} sản phẩm có SKU NULL!")
            response = input("Bạn có muốn tiếp tục set NOT NULL? (y/n): ")
            if response.lower() != 'y':
                print("Đã hủy việc set NOT NULL.")
                return
        
        # Kiểm tra có giá trị trùng lặp không
        cursor.execute("""
            SELECT sku, COUNT(*) as cnt 
            FROM products 
            WHERE sku IS NOT NULL
            GROUP BY sku 
            HAVING cnt > 1
        """)
        duplicates = cursor.fetchall()
        
        if duplicates:
            print(f"CẢNH BÁO: Có {len(duplicates)} SKU bị trùng lặp!")
            print("Các SKU trùng lặp:", duplicates[:5])
            response = input("Bạn có muốn tiếp tục set UNIQUE? (y/n): ")
            if response.lower() != 'y':
                print("Đã hủy việc set UNIQUE.")
                return
        
        # Set NOT NULL
        cursor.execute("""
            ALTER TABLE products 
            MODIFY COLUMN sku VARCHAR(50) NOT NULL
        """)
        conn.commit()
        print("Đã set cột sku là NOT NULL!")
        
        # Set UNIQUE
        cursor.execute("""
            ALTER TABLE products 
            ADD UNIQUE KEY unique_sku (sku)
        """)
        conn.commit()
        print("Đã set cột sku là UNIQUE!")
        
        print("\n" + "=" * 60)
        print("HOÀN THÀNH!")
        print("=" * 60)
        print(f"✓ Đã thêm cột sku vào bảng products")
        print(f"✓ Đã update SKU cho {existing_count} sản phẩm hiện có")
        print(f"✓ Đã insert {new_products_count} sản phẩm mới (KHÔNG có category_id)")
        print(f"✓ Tổng số sản phẩm: {total_count}")
        print(f"✓ Đã set cột sku là NOT NULL và UNIQUE")
        
    except Exception as e:
        print(f"\nLỖI: {e}")
        conn.rollback()
        raise
    finally:
        cursor.close()
        conn.close()
        print("\nĐã đóng kết nối database.")

if __name__ == '__main__':
    main()



