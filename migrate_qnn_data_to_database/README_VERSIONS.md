# So Sánh Các Phiên Bản Script Migration

## Tổng Quan

Có 2 phiên bản script migration để thêm cột `sku` vào bảng `products`:

1. **migrate_add_sku.py** - Phiên bản có `category_id`
2. **migrate_add_sku_Non_categoryid.py** - Phiên bản KHÔNG có `category_id`

## So Sánh Chi Tiết

### 1. migrate_add_sku.py (CÓ category_id)

**Sử dụng khi**: Bảng `products` có trường `category_id` với foreign key đến bảng `categories`

#### Đặc điểm:
- ✅ Lấy danh sách `category_ids` từ database
- ✅ Random `category_id` khi tạo sản phẩm mới
- ✅ INSERT query bao gồm trường `category_id`

#### Cấu trúc INSERT:
```sql
INSERT INTO products 
(name, description, category_id, unit_price, weight, volume, 
 is_fragile, stock_quantity, product_status, warehouse_id,
 created_at, updated_at, created_by, notes, sku)
VALUES 
(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
```

#### Foreign Keys được sử dụng:
- ✅ `category_id` → `categories(id)`
- ✅ `warehouse_id` → `warehouses(id)`
- ✅ `created_by` → `users(id)`

---

### 2. migrate_add_sku_Non_categoryid.py (KHÔNG có category_id)

**Sử dụng khi**: Bảng `products` KHÔNG có trường `category_id`

#### Đặc điểm:
- ❌ KHÔNG lấy `category_ids` từ database
- ❌ KHÔNG random `category_id` khi tạo sản phẩm mới
- ❌ INSERT query KHÔNG bao gồm trường `category_id`

#### Cấu trúc INSERT:
```sql
INSERT INTO products 
(name, description, unit_price, weight, volume, 
 is_fragile, stock_quantity, product_status, warehouse_id,
 created_at, updated_at, created_by, notes, sku)
VALUES 
(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
```

#### Foreign Keys được sử dụng:
- ❌ `category_id` (KHÔNG có)
- ✅ `warehouse_id` → `warehouses(id)`
- ✅ `created_by` → `users(id)`

---

## Bảng So Sánh

| Tính năng | migrate_add_sku.py | migrate_add_sku_Non_categoryid.py |
|-----------|-------------------|-----------------------------------|
| **Database** | fastroute | fastroute |
| **Thêm cột SKU** | ✅ | ✅ |
| **Update SKU cho row cũ** | ✅ | ✅ |
| **Insert row mới** | ✅ | ✅ |
| **Set NOT NULL & UNIQUE** | ✅ | ✅ |
| **Sử dụng category_id** | ✅ | ❌ |
| **Lấy categories từ DB** | ✅ (54 categories) | ❌ |
| **Lấy warehouses từ DB** | ✅ (22 warehouses) | ✅ (22 warehouses) |
| **Lấy users từ DB** | ✅ (500 users) | ✅ (500 users) |
| **Số trường trong INSERT** | 15 trường | 14 trường |

---

## Cách Sử Dụng

### Kiểm tra cấu trúc bảng của bạn:
```sql
-- Kiểm tra xem bảng products có trường category_id không
DESCRIBE products;

-- Hoặc
SHOW CREATE TABLE products;
```

### Nếu CÓ category_id:
```bash
cd /Users/mac/Downloads/abcd/migrate_database
python3 migrate_add_sku.py
```

### Nếu KHÔNG CÓ category_id:
```bash
cd /Users/mac/Downloads/abcd/migrate_database
python3 migrate_add_sku_Non_categoryid.py
```

---

## Kết Quả Giống Nhau

Cả 2 phiên bản đều tạo ra kết quả tương tự:
- ✅ 61,589 sản phẩm với SKU duy nhất
- ✅ 209 sản phẩm cũ được update SKU
- ✅ 61,380 sản phẩm mới được insert
- ✅ Cột `sku` VARCHAR(50) NOT NULL UNIQUE
- ✅ Tất cả SKU lấy từ file `BackOrders_sku_only.csv`

---

## Lưu Ý Quan Trọng

⚠️ **CẢNH BÁO**: Chọn đúng phiên bản phù hợp với cấu trúc bảng của bạn!

- Nếu bảng CÓ `category_id` mà chạy phiên bản Non_categoryid → Các sản phẩm mới sẽ KHÔNG có category_id (có thể NULL hoặc lỗi nếu NOT NULL)
- Nếu bảng KHÔNG CÓ `category_id` mà chạy phiên bản có category_id → Lỗi SQL vì trường không tồn tại

---

## Tác Giả
Script được tạo để migration dữ liệu SKU từ file CSV vào database MySQL.



