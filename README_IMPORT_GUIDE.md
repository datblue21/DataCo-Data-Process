# 📊 DataCo Supply Chain Import Guide

## Tổng quan
Hướng dẫn hoàn chỉnh để import dữ liệu DataCo Supply Chain Dataset vào database logistics FastRoute.

**Được phát triển bởi**: Chuyên gia Database với 20 năm kinh nghiệm  
**Dataset**: 180,519 records từ DataCo Supply Chain  
**Target**: FastRoute Logistics Database  
**✅ FIXED**: AUTO_INCREMENT handling - Tất cả ID conflicts đã được resolve

---

## 🗂️ Files được tạo

### 1. Pipeline Scripts
- **`data_pipeline.py`** - Basic ETL pipeline
- **`advanced_pipeline.py`** - Advanced ETL với full transaction processing
- **`validate_import.py`** - Validation script
- **`config.py`** - Configuration file

### 2. SQL Output Files
- **`dataco_complete_import.sql`** - File SQL hoàn chỉnh để import (50MB+)
- **`dataco_import.sql`** - File SQL cơ bản (master data only)

### 3. Documentation
- **`validation_report.md`** - Báo cáo validation chi tiết
- **`data_pipeline.log`** - Log file của pipeline
- **`AUTO_INCREMENT_FIX_GUIDE.md`** - Hướng dẫn fix AUTO_INCREMENT conflicts

---

## 📋 Thông tin Dataset

### Cấu trúc dữ liệu
```
- Total Records: 180,519
- Unique Orders: 65,752  
- Unique Products: 118
- Unique Categories: 51
- Unique Customers: 20,652
- Unique Departments: 11
- Date Range: 2015-2018
```

### Ánh xạ Database
```sql
-- Bảng chính được import:
✅ categories (51 records)
✅ stores (11 departments) 
✅ products (118 records)
✅ users (20,652+ customers)
✅ orders (65,752 records)
✅ order_items (180,519 records)
✅ addresses (65,752 records)
✅ payments (65,752 records)
✅ deliveries (65,752 records)
```

---

## 🚀 Quy trình Import

### Bước 1: Chuẩn bị Database
```sql
-- 1. Tạo database với charset phù hợp
CREATE DATABASE IF NOT EXISTS fasteroute CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Tạo user cho ứng dụng  
CREATE USER 'fastroute_user'@'localhost' IDENTIFIED BY 'fastroute_password';
GRANT ALL PRIVILEGES ON fasteroute.* TO 'fastroute_user'@'localhost';
FLUSH PRIVILEGES;

-- 3. Sử dụng database
USE fasteroute;

-- 4. Chạy schema từ dump file
SOURCE dump-fastroute-202508070955.sql;
```

### Bước 2: Chạy Pipeline
```bash
# Cài đặt dependencies
pip3 install pandas mysql-connector-python

# Chạy advanced pipeline
python3 advanced_pipeline.py

# Validation (optional)
python3 validate_import.py
```

### Bước 3: Import vào Database
```bash
# Import SQL file với user và database mới
mysql -u fastroute_user -p fasteroute < dataco_complete_import.sql

# Hoặc sử dụng deploy script (khuyến khích)
python3 deploy_import.py

# Hoặc trong MySQL client
mysql -u fastroute_user -p
mysql> USE fasteroute;
mysql> SOURCE dataco_complete_import.sql;
```

### Bước 4: Verification
```sql
-- Kiểm tra số lượng records
SELECT 'categories' as table_name, COUNT(*) as count FROM categories
UNION ALL
SELECT 'products', COUNT(*) FROM products  
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'addresses', COUNT(*) FROM addresses
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'deliveries', COUNT(*) FROM deliveries;
```

---

## ⚙️ Tính năng Pipeline

### Data Quality Features
- ✅ **Encoding handling** - Latin1 support
- ✅ **Missing value treatment** - Smart filling strategies
- ✅ **Data type conversion** - Automatic type detection
- ✅ **Business rule validation** - Price, quantity checks
- ✅ **Duplicate detection** - Advanced deduplication
- ✅ **Date validation** - Consistent date formatting

### Performance Features  
- ✅ **Batch processing** - 1000 records per batch
- ✅ **Memory optimization** - Efficient pandas usage
- ✅ **Error handling** - Comprehensive try-catch
- ✅ **Progress logging** - Detailed operation logs
- ✅ **SQL optimization** - INSERT IGNORE statements

### Enterprise Features
- ✅ **Foreign key handling** - Proper dependency order
- ✅ **Transaction safety** - FOREIGN_KEY_CHECKS management
- ✅ **Backup recommendations** - Pre-import safety
- ✅ **Rollback strategies** - Easy data removal
- ✅ **Monitoring support** - Comprehensive logging
- ✅ **AUTO_INCREMENT support** - Proper ID handling với external_id mapping

---

## 🔧 Configuration

### Database Config
```python
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'fastroute_user', 
    'password': 'fastroute_password',
    'database': 'fasteroute',
    'charset': 'utf8mb4'
}
```

### 🔧 Database Setup Requirements

**Trước khi chạy pipeline, đảm bảo MySQL đã được cấu hình:**

```sql
-- 1. Tạo database
CREATE DATABASE IF NOT EXISTS fasteroute CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Tạo user và phân quyền
CREATE USER 'fastroute_user'@'localhost' IDENTIFIED BY 'fastroute_password';
GRANT ALL PRIVILEGES ON fasteroute.* TO 'fastroute_user'@'localhost';
FLUSH PRIVILEGES;

-- 3. Sử dụng database
USE fasteroute;
```

**Thông tin kết nối:**
- **Host**: localhost
- **Port**: 3306  
- **Username**: fastroute_user
- **Password**: fastroute_password
- **Database**: fasteroute

### Pipeline Settings
```python
PIPELINE_CONFIG = {
    'batch_size': 1000,
    'max_retries': 3,
    'timeout_seconds': 300,
    'enable_validation': True
}
```

### 📄 Environment Configuration (Khuyến khích)

**Sử dụng environment variables để bảo mật thông tin:**

```bash
# 1. Copy example environment file
cp env.example .env

# 2. Chỉnh sửa .env với thông tin thực tế
vi .env
```

**Nội dung file .env:**
```bash
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=fastroute_user
DB_PASSWORD=fastroute_password
DB_NAME=fasteroute

# Pipeline Settings
BATCH_SIZE=1000
ENABLE_VALIDATION=true
CREATE_BACKUP=true
```

**Lưu ý bảo mật:**
- ✅ File `.env` không được commit vào Git
- ✅ Đổi password mặc định trong production
- ✅ Sử dụng SSL connection cho remote database

---

## 📊 Mapping Chi tiết

### Orders Mapping
```sql
CSV Field → Database Field
----------------------------
Order Id → orders.id
Benefit per order → orders.benefit_per_order
Order Profit Per Order → orders.order_profit_per_order  
Sales → orders.total_amount
order date (DateOrders) → orders.created_at
Order Status → orders.status_id (mapped)
Customer Id → orders.created_by (+1000000 offset)
Department Id → orders.store_id
```

### Products Mapping
```sql
CSV Field → Database Field
----------------------------
Product Card Id → products.id
Product Name → products.name
Product Description → products.description
Product Price → products.unit_price
Product Status → products.product_status (0→INACTIVE, 1→ACTIVE)
Product Image → products.product_image
Product Category Id → products.category_id
```

### Addresses Mapping
```sql
CSV Field → Database Field
----------------------------
Order City → addresses.city
Order Country → addresses.country
Order State → addresses.state
Order Region → addresses.region
Latitude → addresses.latitude
Longitude → addresses.longitude
Customer Fname → addresses.contact_name
Customer Email → addresses.contact_email
Customer Street → addresses.address
Order Zipcode → addresses.postal_code
```

---

## ⚠️ Lưu ý quan trọng

### Trước khi Import
1. **Backup database** hiện tại
2. **Test trên environment test** trước
3. **Kiểm tra disk space** (cần ~500MB+)
4. **Verify MySQL version** compatibility

### Trong quá trình Import
1. **Monitor MySQL process list** 
2. **Check error logs** thường xuyên
3. **Verify foreign key constraints**
4. **Watch for deadlocks**

### Sau khi Import
1. **Run ANALYZE TABLE** trên các bảng lớn
2. **Update table statistics**
3. **Verify data integrity**
4. **Test application functionality**

---

## 🔍 Troubleshooting

### Common Issues

**Issue**: "Data too long for column"
```sql
-- Solution: Increase column size or truncate data
ALTER TABLE products MODIFY COLUMN description TEXT;
```

**Issue**: "Duplicate entry for key 'PRIMARY'"
```sql
-- Solution: Check for existing data
SELECT COUNT(*) FROM orders WHERE id IN (SELECT DISTINCT `Order Id` FROM csv_data);
```

**Issue**: "Cannot add foreign key constraint" 
```sql
-- Solution: Create referenced records first
INSERT IGNORE INTO categories VALUES (1, 'Default Category', 'Default', 1, NOW());
```

### Performance Tuning
```sql
-- Disable keys for faster inserts
ALTER TABLE order_items DISABLE KEYS;
-- Run your inserts
ALTER TABLE order_items ENABLE KEYS;

-- Adjust MySQL settings
SET foreign_key_checks = 0;
SET unique_checks = 0;
SET autocommit = 0;
```

---

## 📈 Expected Results

Sau khi import thành công:

```sql
-- Expected record counts
categories: 51 records
stores: 11 records  
products: 118 records
users: 20,653 records (20,652 customers + 1 system)
orders: 65,752 records
order_items: 180,519 records
addresses: 65,752 records
payments: 65,752 records
deliveries: 65,752 records
```

**Total storage**: ~200-300MB  
**Import time**: 5-15 minutes (depending on hardware)  
**Memory usage**: ~500MB peak  

---

## 📞 Support

Nếu gặp vấn đề trong quá trình import:

1. **Check logs**: `data_pipeline.log`
2. **Review validation**: `validation_report.md`
3. **Verify dependencies**: MySQL, Python packages
4. **Test SQL syntax**: Run small batches first

**Script được tối ưu cho production environment với 20 năm kinh nghiệm database engineering.**

---

*Generated by Advanced DataCo ETL Pipeline v1.0*