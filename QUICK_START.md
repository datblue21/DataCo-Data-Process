# 🚀 DataCo ETL Pipeline - Quick Start Guide

## Thiết lập nhanh trong 5 phút!

### 📋 Bước 1: Chuẩn bị MySQL Database

```sql
-- Chạy các lệnh SQL này trong MySQL:

-- 1. Tạo database
CREATE DATABASE IF NOT EXISTS fasteroute CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Tạo user
CREATE USER 'fastroute_user'@'localhost' IDENTIFIED BY 'fastroute_password';
GRANT ALL PRIVILEGES ON fasteroute.* TO 'fastroute_user'@'localhost';
FLUSH PRIVILEGES;

-- 3. Import schema
USE fasteroute;
SOURCE dump-fastroute-202508070955.sql;
```

### 🐍 Bước 2: Cài đặt Python Dependencies

```bash
pip3 install pandas mysql-connector-python
```

### ⚙️ Bước 3: Cấu hình Environment (Tùy chọn)

```bash
# Copy và chỉnh sửa file environment
cp env.example .env

# Hoặc sử dụng cấu hình mặc định:
# Host: localhost:3306
# User: fastroute_user  
# Password: fastroute_password
# Database: fasteroute
```

### 🏃‍♂️ Bước 4: Chạy ETL Pipeline

```bash
# Tạo SQL import file
python3 advanced_pipeline.py

# Validation (khuyến khích)
python3 validate_import.py

# Import vào database
python3 deploy_import.py
```

### ✅ Bước 5: Kiểm tra kết quả

```sql
-- Kiểm tra số lượng records
USE fasteroute;
SELECT 'categories' as table_name, COUNT(*) as count FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products  
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

-- Expected results:
-- categories: 51
-- products: 118  
-- orders: 65,752
-- order_items: 180,519
```

---

## 🔧 Thông tin Database

| Tham số | Giá trị |
|---------|---------|
| **Host** | localhost |
| **Port** | 3306 |
| **Username** | fastroute_user |
| **Password** | fastroute_password |
| **Database** | fasteroute |

---

## 📊 Kết quả mong đợi

Sau khi import thành công:

```
✅ 51 categories imported
✅ 118 products imported  
✅ 65,752 orders imported
✅ 180,519 order items imported
✅ 20,653 users imported
✅ 65,752 addresses imported
✅ 65,752 payments imported
✅ 65,752 deliveries imported

📈 Total: ~600,000+ records
⏱️ Import time: 5-15 minutes
💾 Storage: ~200-300MB
```

---

## 🚨 Troubleshooting

### ❌ Connection Error
```
ERROR: Access denied for user 'fastroute_user'@'localhost'
```
**Giải pháp:** Kiểm tra user đã được tạo và có quyền:
```sql
SHOW GRANTS FOR 'fastroute_user'@'localhost';
```

### ❌ Database Not Found
```
ERROR: Unknown database 'fasteroute'
```
**Giải pháp:** Tạo database:
```sql
CREATE DATABASE fasteroute;
```

### ❌ File Not Found
```
ERROR: [Errno 2] No such file or directory: 'DataCoSupplyChainDataset.csv'
```
**Giải pháp:** Đảm bảo CSV file ở trong thư mục dự án.

---

## 📞 Hỗ trợ

- 📖 **Chi tiết**: Xem `README_IMPORT_GUIDE.md`
- 🔍 **Validation**: Xem `validation_report.md`  
- 🐛 **Logs**: Xem `data_pipeline.log`

**⚡ Sẵn sàng import 180,519 records trong vài phút!**









