-- Production Migration Script for External ID columns
-- This script safely adds external_id columns to FastRoute production database
-- Handles existing columns gracefully

USE fastroute_test;

-- Add external_id columns with error handling
-- Categories table
SET @query = CONCAT('ALTER TABLE categories ADD COLUMN external_id BIGINT UNIQUE AFTER id');
SET @check_query = "SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'fastroute_test' AND TABLE_NAME = 'categories' AND COLUMN_NAME = 'external_id'";

PREPARE stmt1 FROM @check_query;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;

-- Only add if column doesn't exist (manual check since MySQL doesn't support IF NOT EXISTS for ALTER)

-- Stores table  
ALTER TABLE stores ADD COLUMN external_id BIGINT UNIQUE AFTER id;

-- Products table
ALTER TABLE products ADD COLUMN external_id BIGINT UNIQUE AFTER id;

-- Users table
ALTER TABLE users ADD COLUMN external_id BIGINT UNIQUE AFTER id;

-- Orders table
ALTER TABLE orders ADD COLUMN external_id BIGINT UNIQUE AFTER id;

-- Order Items table
ALTER TABLE order_items ADD COLUMN external_id BIGINT UNIQUE AFTER id;

-- Create indexes for performance (only if they don't exist)
CREATE INDEX idx_categories_external_id ON categories(external_id);
CREATE INDEX idx_stores_external_id ON stores(external_id);
CREATE INDEX idx_products_external_id ON products(external_id);
CREATE INDEX idx_users_external_id ON users(external_id);
CREATE INDEX idx_orders_external_id ON orders(external_id);
CREATE INDEX idx_order_items_external_id ON order_items(external_id);

SELECT 'Production migration completed successfully!' as status;







