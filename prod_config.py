#!/usr/bin/env python3
"""
Production Configuration cho DataCo ETL Pipeline
==============================================
Cấu hình production database cho server.aptech.io
"""

import os
from typing import Dict, Any

# Production Database Configuration
PRODUCTION_DB_CONFIG = {
    'host': 'server.aptech.io',
    'user': 'fastroute_user', 
    'password': 'fastroute_password',
    'database': 'fastroute_test',
    'port': 3307,
    'charset': 'utf8mb4',
    'autocommit': False,  # Production: disable autocommit for transactions
    'raise_on_warnings': True,
    'connect_timeout': 30,
    'read_timeout': 300,
    'write_timeout': 300
}

# Production Pipeline settings - more conservative
PRODUCTION_PIPELINE_CONFIG = {
    'batch_size': 500,    # Smaller batches for production stability
    'max_retries': 5,     # More retries for network reliability
    'timeout_seconds': 600,  # Longer timeout for production
    'enable_validation': True,
    'create_backup': True,
    'enable_transactions': True,  # Critical for production
    'rollback_on_error': True,
    'verify_checksums': True
}

# Production Business Rules - stricter
PRODUCTION_BUSINESS_RULES = {
    'min_price': 0.01,
    'max_price': 999999.99,
    'min_quantity': 1,
    'max_quantity': 10000,
    'required_fields': [
        'Order Id', 'Product Card Id', 'Category Id',
        'Order Item Id', 'Customer Id'
    ],
    'enable_data_encryption': True,
    'log_all_operations': True
}

# Production Data Quality - stricter thresholds
PRODUCTION_DATA_QUALITY = {
    'max_null_percentage': 2.0,     # Stricter for production
    'max_duplicate_percentage': 0.5, # Very strict for duplicates
    'min_data_completeness': 98.0,   # Higher completeness requirement
    'enable_data_profiling': True,
    'enable_anomaly_detection': True
}

# Production Monitoring
PRODUCTION_MONITORING = {
    'enable_performance_logging': True,
    'log_slow_queries': True,
    'slow_query_threshold': 5.0,  # seconds
    'enable_progress_tracking': True,
    'enable_error_notifications': True
}

# Security Settings
PRODUCTION_SECURITY = {
    'enable_ssl': True,
    'verify_ssl_cert': True,
    'log_sensitive_data': False,
    'mask_passwords_in_logs': True,
    'enable_audit_trail': True
}

# File paths for production
PRODUCTION_PATHS = {
    'csv_file': 'DataCoSupplyChainDataset.csv',
    'output_sql_file': 'dataco_production_import.sql',
    'log_file': 'production_pipeline.log',
    'backup_dir': 'production_backups/',
    'error_log': 'production_errors.log'
}







