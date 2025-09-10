# Bảng Ánh Xạ Dataset DataCo vào Database Logistics

## Tổng quan
Tài liệu này mô tả cách ánh xạ dữ liệu từ dataset DataCo Supply Chain vào cơ sở dữ liệu logistics hiện có mà không cần tạo bảng mới hay thay đổi cấu trúc ID.

## 1. Bảng `orders` (đã tồn tại)

**Trường dataset → Trường database:**
- `Benefit per order` → `benefit_per_order` ✅
- `Order Profit Per Order` → `order_profit_per_order` ✅ 
- `Sales` → `total_amount` ✅
- `order date (DateOrders)` → `created_at` ✅

## 2. Bảng `order_items` (đã tồn tại)

**Trường dataset → Trường database:**
- `Order Item Quantity` → `quantity` ✅
- `Order Item Product Price` → `unit_price` ✅


## 3. Bảng `products` (đã tồn tại)

**Trường dataset → Trường database:**
- `Product Name` → `name` ✅
- `Product Description` → `description` ✅
- `Product Price` → `unit_price` ✅
- `Product Status` → `product_status` ✅
- `Product Image` → `product_image` ✅

## 4. Bảng `categories` (đã tồn tại)

**Trường dataset → Trường database:**
- `Category Name` → `name` ✅

## 5. Bảng `deliveries` (đã tồn tại)

**Trường dataset → Trường database:**

- `shipping date (DateOrders)` → `actual_delivery_time` ✅
- `Late_delivery_risk` → `late_delivery_risk` ✅
- `Shipping Mode` → `service_type` ✅

**Ánh xạ giá trị Shipping Mode:**
- `Standard Class` → `STANDARD`
- `First Class` → `FIRST_CLASS`
- `Second Class` → `SECOND_CLASS`
- `Same Day` → `SAME_DAY`

## 6. Bảng `addresses` (đã tồn tại)

**Trường dataset → Trường database:**
- `Order City` → `city` ✅
- `Order Country` → `country` ✅
- `Order State` → `state` ✅
- `Order Region` → `region` ✅
- `Latitude` → `latitude` ✅
- `Longitude` → `longitude` ✅

## 7. Bảng `stores` (đã tồn tại)

**Trường dataset → Trường database:**
- `Department Name` → `store_name` ✅

## 8. Bảng `payments` (đã tồn tại)

**Trường dataset → Trường database:**
- `Type` → `payment_method` ✅

**Ánh xạ giá trị Type:**
- `DEBIT` → `DEBIT`
- `TRANSFER` → `TRANSFER`
- `CASH` → `CASH`

## 10. Thông tin khách hàng

**Trường dataset có thể lưu trong các bảng hiện có:**
- `Customer Fname` → Có thể lưu trong `contact_name` của bảng `addresses`
- `Customer Segment` → Có thể lưu trong `notes` của bảng `orders`
- `Customer City` → `city` trong bảng `addresses`
- `Customer Country` → `country` trong bảng `addresses`
- `Customer State` → `state` trong bảng `addresses`
- `Customer Street` → `address` trong bảng `addresses`
- `Customer Zipcode` → `postal_code` trong bảng `addresses`

## Kết luận

Dataset DataCo có thể được tích hợp hoàn toàn vào database logistics hiện tại với các điều chỉnh tối thiểu:

1. **Không cần tạo bảng mới**
2. **Không cần thay đổi cấu trúc ID vì id trong database đã là AUTO_INCREMENT**
3. **Sử dụng các bảng hiện có** 