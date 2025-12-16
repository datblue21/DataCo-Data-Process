# Hướng dẫn migrate & import dữ liệu AI Features

## 1. Chạy script migrate_add_sku.py

Trước khi chạy, hãy mở file **`migrate_add_sku.py`** và **chỉnh sửa các
thông số kết nối MySQL**:

-   Tên tài khoản (user)\
-   Mật khẩu (password)\
-   Tên cơ sở dữ liệu (database)

Sau khi chỉnh sửa, chạy script:

``` bash
python migrate_add_sku.py
```

## 2. Tạo bảng `product_ai_features`

``` sql
CREATE TABLE product_ai_features (
    sku VARCHAR(50) NOT NULL PRIMARY KEY,
    national_inv INT DEFAULT NULL,
    lead_time VARCHAR(10) DEFAULT NULL,
    in_transit_qty INT DEFAULT NULL,
    forecast_3_month DECIMAL(10,2) DEFAULT NULL,
    forecast_6_month DECIMAL(10,2) DEFAULT NULL,
    forecast_9_month DECIMAL(10,2) DEFAULT NULL,
    sales_1_month DECIMAL(10,2) DEFAULT NULL,
    sales_3_month DECIMAL(10,2) DEFAULT NULL,
    sales_6_month DECIMAL(10,2) DEFAULT NULL,
    sales_9_month DECIMAL(10,2) DEFAULT NULL,
    min_bank INT DEFAULT NULL,
    potential_issue VARCHAR(255) DEFAULT NULL,
    pieces_past_due INT DEFAULT NULL,
    perf_6_month_avg DECIMAL(6,4) DEFAULT NULL,
    perf_12_month_avg DECIMAL(6,4) DEFAULT NULL,
    local_bo_qty INT DEFAULT NULL,
    deck_risk VARCHAR(3) DEFAULT NULL,
    oe_constraint VARCHAR(3) DEFAULT NULL,
    ppap_risk VARCHAR(3) DEFAULT NULL,
    stop_auto_buy VARCHAR(3) DEFAULT NULL,
    rev_stop VARCHAR(3) DEFAULT NULL,
    went_on_backorder VARCHAR(3) DEFAULT NULL,
    FOREIGN KEY (sku) REFERENCES products(sku)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_went_on_backorder (went_on_backorder),
    INDEX idx_national_inv (national_inv),
    INDEX idx_forecast (forecast_3_month, forecast_6_month, forecast_9_month)
);
```

## 3. Import dữ liệu CSV `back_order` vào bảng `product_ai_features`



Cách 1: Import trực tiếp bằng MySQL Workbench

Cách 2: 

``` sql
LOAD DATA INFILE '/path/to/back_order.csv'
INTO TABLE product_ai_features
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```
