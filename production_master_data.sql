-- Production Master Data Script
-- Import master data first to avoid foreign key issues
USE fastroute_test;

-- Status master data
INSERT IGNORE INTO status (type, name, description, created_at, updated_at) VALUES
('ORDER', 'Pending', 'Awaiting processing', NOW(), NOW()),
('ORDER', 'Completed', 'Order completed', NOW(), NOW()),
('ORDER', 'Cancelled', 'Order cancelled', NOW(), NOW()),
('ORDER', 'Processing', 'Order being processed', NOW(), NOW()),
('ORDER', 'Shipped', 'Order shipped', NOW(), NOW()),
('ORDER', 'Delivered', 'Order delivered', NOW(), NOW()),
('USER', 'Active', 'Currently active', NOW(), NOW()),
('USER', 'Inactive', 'Currently inactive', NOW(), NOW()),
('USER', 'Suspended', 'Account suspended', NOW(), NOW()),
('PAYMENT', 'Pending', 'Payment pending', NOW(), NOW()),
('PAYMENT', 'Completed', 'Payment completed', NOW(), NOW()),
('PAYMENT', 'Failed', 'Payment failed', NOW(), NOW()),
('DELIVERY', 'Scheduled', 'Delivery scheduled', NOW(), NOW()),
('DELIVERY', 'In Transit', 'Package in transit', NOW(), NOW()),
('DELIVERY', 'Delivered', 'Package delivered', NOW(), NOW()),
('DELIVERY', 'Failed', 'Delivery failed', NOW(), NOW()),
('VEHICLE', 'AVAILABLE', 'Vehicle available for use', NOW(), NOW()),
('VEHICLE', 'IN_USE', 'Vehicle currently in use', NOW(), NOW()),
('VEHICLE', 'MAINTENANCE', 'Vehicle under maintenance', NOW(), NOW());

-- Roles master data
INSERT IGNORE INTO roles (role_name, description, is_active, created_at) VALUES
('ADMIN', 'Administrator role', 1, NOW()),
('MANAGER', 'Manager role', 1, NOW()),
('USER', 'Standard user role', 1, NOW()),
('CUSTOMER', 'Default customer role', 1, NOW());

SELECT 'Master data imported successfully!' as status;
