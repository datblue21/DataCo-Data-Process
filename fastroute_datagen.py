#!/usr/bin/env python3
"""
FastRoute Data Generation System
===============================
Enterprise-grade data generation cho hệ thống logistics FastRoute
với Vietnamese locale và business logic thực tế.

Author: Data Expert (20+ years experience)
Date: 2025-08-11
"""

import pandas as pd
import mysql.connector
from mysql.connector import pooling
import logging
import sys
import json
import random
import numpy as np
from datetime import datetime, timedelta
from typing import Dict, List, Any, Optional, Tuple
from faker import Faker
from faker.providers import BaseProvider
import geopy.distance
from geopy import Point
import uuid
from dataclasses import dataclass
from concurrent.futures import ThreadPoolExecutor
import threading
from tqdm import tqdm
import time

# Vietnamese Faker
fake = Faker('vi_VN')

@dataclass
class GenerationConfig:
    """Configuration cho data generation."""
    
    # Scale settings
    scale: str = "medium"  # small, medium, large
    
    # Master data counts
    addresses_count: int = 1500
    users_count: int = 500
    stores_count: int = 150
    warehouses_count: int = 20
    vehicles_count: int = 100
    routes_count: int = 50
    
    # Transactional data counts
    orders_count: int = 15000
    delivery_tracking_records: int = 75000
    warehouse_transactions_count: int = 30000
    activity_logs_count: int = 50000
    
    # Business logic
    major_cities = [
        {"name": "TP.HCM", "lat": 10.8231, "lng": 106.6297, "weight": 0.35},
        {"name": "Hà Nội", "lat": 21.0285, "lng": 105.8542, "weight": 0.25},
        {"name": "Đà Nẵng", "lat": 16.0544, "lng": 108.2022, "weight": 0.15},
        {"name": "Cần Thơ", "lat": 10.0452, "lng": 105.7469, "weight": 0.10},
        {"name": "Hải Phòng", "lat": 20.8449, "lng": 106.6881, "weight": 0.08},
        {"name": "Nha Trang", "lat": 12.2388, "lng": 109.1967, "weight": 0.07}
    ]
    
    # Vehicle distribution
    vehicle_types = [
        {"type": "TRUCK", "weight": 0.40, "capacity_kg": (1000, 5000), "capacity_m3": (10, 50)},
        {"type": "VAN", "weight": 0.35, "capacity_kg": (300, 1500), "capacity_m3": (3, 15)},
        {"type": "MOTORCYCLE", "weight": 0.25, "capacity_kg": (10, 100), "capacity_m3": (0.1, 2)}
    ]
    
    # Rush hours for orders
    rush_hours = [(9, 11), (14, 16), (19, 21)]
    
    def __post_init__(self):
        """Adjust counts based on scale."""
        if self.scale == "small":
            self.addresses_count = 500
            self.users_count = 200
            self.stores_count = 50
            self.orders_count = 5000
            self.delivery_tracking_records = 25000
        elif self.scale == "large":
            self.addresses_count = 3000
            self.users_count = 1000
            self.stores_count = 300
            self.orders_count = 50000
            self.delivery_tracking_records = 250000

class VietnamLicensePlateProvider(BaseProvider):
    """Custom provider for Vietnamese license plates."""
    
    def vietnam_license_plate(self) -> str:
        """Generate realistic Vietnamese license plate."""
        # Format: 51A-12345.67 hoặc 29A-123.45
        city_codes = ['51', '50', '30', '29', '43', '77', '15', '92', '65']
        city_code = self.random_element(city_codes)
        letter = self.random_element(['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'])
        
        if self.random_int(0, 1):
            # 5-digit format
            numbers = f"{self.random_int(10000, 99999)}"
            suffix = f"{self.random_int(10, 99)}"
            return f"{city_code}{letter}-{numbers}.{suffix}"
        else:
            # 3-digit format  
            numbers = f"{self.random_int(100, 999)}"
            suffix = f"{self.random_int(10, 99)}"
            return f"{city_code}{letter}-{numbers}.{suffix}"

fake.add_provider(VietnamLicensePlateProvider)

class DatabaseManager:
    """Database connection manager với pooling."""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.pool = None
        self.logger = logging.getLogger(__name__)
        self._setup_connection_pool()
        
    def _setup_connection_pool(self):
        """Setup connection pool."""
        try:
            pool_config = {
                **self.config,
                'pool_name': 'fastroute_pool',
                'pool_size': 10,
                'pool_reset_session': True,
                'autocommit': False
            }
            self.pool = pooling.MySQLConnectionPool(**pool_config)
            self.logger.info("✅ Database connection pool initialized")
        except Exception as e:
            self.logger.error(f"❌ Failed to initialize connection pool: {e}")
            raise
            
    def get_connection(self):
        """Get connection from pool."""
        return self.pool.get_connection()
        
    def execute_batch(self, sql: str, data: List[Tuple], batch_size: int = 1000) -> int:
        """Execute batch insert với progress tracking."""
        connection = None
        cursor = None
        total_inserted = 0
        
        try:
            connection = self.get_connection()
            cursor = connection.cursor()
            
            # Disable foreign key checks for performance
            cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
            
            # Process in batches
            for i in tqdm(range(0, len(data), batch_size), desc="Inserting batches"):
                batch = data[i:i + batch_size]
                cursor.executemany(sql, batch)
                total_inserted += cursor.rowcount
                
                # Commit every batch
                connection.commit()
                
            # Re-enable foreign key checks
            cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
            connection.commit()
            
            self.logger.info(f"✅ Inserted {total_inserted} records")
            return total_inserted
            
        except Exception as e:
            if connection:
                connection.rollback()
            self.logger.error(f"❌ Batch execution failed: {e}")
            raise
        finally:
            if cursor:
                cursor.close()
            if connection:
                connection.close()

class FastRouteDataGenerator:
    """Main data generator class."""
    
    def __init__(self, db_config: Dict[str, Any], gen_config: GenerationConfig):
        self.db = DatabaseManager(db_config)
        self.config = gen_config
        self.logger = self._setup_logging()
        
        # Cache for foreign keys
        self.cache = {
            'addresses': {},
            'users': {},
            'stores': {},
            'warehouses': {},
            'vehicles': {},
            'categories': {},
            'products': {},
            'status': {},
            'roles': {}
        }
        
    def _setup_logging(self) -> logging.Logger:
        """Setup logging."""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('fastroute_datagen.log'),
                logging.StreamHandler(sys.stdout)
            ]
        )
        return logging.getLogger(__name__)
        
    def _load_cache(self):
        """Load existing IDs vào cache."""
        connection = self.db.get_connection()
        cursor = connection.cursor()
        
        try:
            # Load existing data
            tables = ['addresses', 'users', 'stores', 'warehouses', 'vehicles', 
                     'categories', 'products', 'status', 'roles']
            
            for table in tables:
                cursor.execute(f"SELECT id FROM {table}")
                ids = [row[0] for row in cursor.fetchall()]
                self.cache[table] = ids
                self.logger.info(f"📋 Loaded {len(ids)} {table} IDs")
                
        finally:
            cursor.close()
            connection.close()
            
    def _get_random_coordinates(self, city_info: Dict) -> Tuple[float, float]:
        """Generate random coordinates quanh city center."""
        center_lat = city_info["lat"]
        center_lng = city_info["lng"]
        
        # Add noise trong bán kính 20km
        radius_km = random.uniform(1, 20)
        angle = random.uniform(0, 360)
        
        # Calculate offset
        point = geopy.distance.distance(kilometers=radius_km).destination(
            Point(center_lat, center_lng), angle
        )
        
        return round(point.latitude, 6), round(point.longitude, 6)
        
    def generate_addresses(self, count: int) -> List[Tuple]:
        """Generate addresses tập trung vào major cities."""
        self.logger.info(f"🏠 Generating {count} addresses...")
        
        addresses = []
        for _ in range(count):
            # Chọn city theo weight
            city = np.random.choice(
                [c["name"] for c in self.config.major_cities],
                p=[c["weight"] for c in self.config.major_cities]
            )
            city_info = next(c for c in self.config.major_cities if c["name"] == city)
            
            lat, lng = self._get_random_coordinates(city_info)
            
            address_types = ['HOME', 'OFFICE', 'WAREHOUSE', 'STORE']
            
            addresses.append((
                fake.random_element(address_types),
                fake.address(),
                city,
                fake.random_element(['Việt Nam']),
                fake.random_element(['Miền Nam', 'Miền Bắc', 'Miền Trung']),
                fake.postcode(),
                lat,
                lng,
                fake.name(),
                fake.email(),
                fake.phone_number(),
                datetime.now()
            ))
            
        return addresses
        
    def generate_users(self, count: int) -> List[Tuple]:
        """Generate users với role distribution thực tế."""
        self.logger.info(f"👥 Generating {count} users...")
        
        # Get role IDs
        connection = self.db.get_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT id, role_name FROM roles")
        roles = {name: id for id, name in cursor.fetchall()}
        cursor.close()
        connection.close()
        
        # Role distribution
        role_weights = {
            'CUSTOMER': 0.70,
            'DRIVER': 0.15,
            'ADMIN': 0.05,
            'MANAGER': 0.05,
            'WAREHOUSE_STAFF': 0.03,
            'SUPPORT': 0.02
        }
        
        users = []
        for i in range(count):
            role_name = np.random.choice(
                list(role_weights.keys()),
                p=list(role_weights.values())
            )
            role_id = roles.get(role_name, roles.get('CUSTOMER'))
            
            # Generate status_id (assume ACTIVE = 1)
            status_id = 1 if random.random() > 0.05 else 2  # 95% active
            
            username = fake.user_name() + str(i)
            email = fake.email()
            full_name = fake.name()
            phone = fake.phone_number()
            
            users.append((
                username,
                email,
                full_name,
                role_id,
                status_id,
                phone,
                datetime.now(),
                datetime.now()
            ))
            
        return users
        
    def generate_vehicles(self, count: int) -> List[Tuple]:
        """Generate vehicles với Vietnamese license plates."""
        self.logger.info(f"🚛 Generating {count} vehicles...")
        
        vehicles = []
        for _ in range(count):
            # Chọn vehicle type theo distribution
            vehicle_type_info = np.random.choice(
                self.config.vehicle_types,
                p=[vt["weight"] for vt in self.config.vehicle_types]
            )
            
            vehicle_type = vehicle_type_info["type"]
            capacity_kg = random.randint(*vehicle_type_info["capacity_kg"])
            capacity_m3 = round(random.uniform(*vehicle_type_info["capacity_m3"]), 2)
            
            license_plate = fake.vietnam_license_plate()
            
            # Status: ACTIVE, MAINTENANCE, INACTIVE
            status_id = int(np.random.choice([1, 2, 3], p=[0.8, 0.15, 0.05]))
            
            vehicles.append((
                license_plate,
                vehicle_type,
                capacity_kg,
                capacity_m3,
                status_id,
                datetime.now(),
                datetime.now()
            ))
            
        return vehicles
        
    def generate_orders_with_vehicles(self, count: int) -> List[Tuple]:
        """Generate orders với vehicle_id assignment."""
        self.logger.info(f"📦 Generating {count} orders with vehicle assignments...")
        
        # Load required IDs
        connection = self.db.get_connection()
        cursor = connection.cursor()
        
        cursor.execute("SELECT id FROM users WHERE role_id = (SELECT id FROM roles WHERE role_name = 'CUSTOMER' LIMIT 1)")
        customer_ids = [row[0] for row in cursor.fetchall()]
        
        cursor.execute("SELECT id FROM stores")
        store_ids = [row[0] for row in cursor.fetchall()]
        
        cursor.execute("SELECT id FROM vehicles WHERE status_id = 1")  # Active vehicles
        vehicle_ids = [row[0] for row in cursor.fetchall()]
        
        cursor.execute("SELECT id FROM addresses")
        address_ids = [row[0] for row in cursor.fetchall()]
        
        # Get max external_id to avoid duplicates
        cursor.execute("SELECT COALESCE(MAX(external_id), 0) FROM orders")
        max_external_id = cursor.fetchone()[0]
        
        cursor.close()
        connection.close()
        
        if not customer_ids or not store_ids or not vehicle_ids:
            raise ValueError("❌ Missing required data: customers, stores, or vehicles")
            
        orders = []
        for i in range(count):
            # Temporal patterns - rush hours
            if random.random() < 0.6:  # 60% trong rush hours
                rush_hour = random.choice(self.config.rush_hours)
                hour = random.randint(rush_hour[0], rush_hour[1])
            else:
                hour = random.randint(0, 23)
                
            # Random date trong 6 tháng qua
            days_ago = random.randint(0, 180)
            order_date = datetime.now() - timedelta(days=days_ago)
            order_date = order_date.replace(hour=hour, minute=random.randint(0, 59))
            
            # Order values - Pareto distribution (80/20)
            if random.random() < 0.2:  # 20% high value orders
                total_amount = round(random.uniform(500000, 5000000), 2)
            else:  # 80% normal orders
                total_amount = round(random.uniform(50000, 500000), 2)
                
            # Profit margins
            profit_margin = random.uniform(0.1, 0.25)  # 10-25%
            order_profit = round(total_amount * profit_margin, 2)
            benefit_per_order = round(order_profit * random.uniform(0.5, 0.8), 2)
            
            # Status distribution
            status_weights = [0.05, 0.1, 0.15, 0.6, 0.1]  # pending, confirmed, shipping, delivered, cancelled
            status_id = int(np.random.choice([1, 2, 3, 4, 5], p=status_weights))
            
            orders.append((
                max_external_id + i + 1,  # external_id (unique)
                status_id,
                random.choice(store_ids) if store_ids else None,
                f"Order #{i+1} - {fake.sentence(nb_words=4)}",
                total_amount,
                benefit_per_order,
                order_profit,
                fake.sentence() if random.random() < 0.3 else None,
                order_date,
                order_date,
                random.choice(customer_ids),
                random.choice(address_ids) if address_ids else None,
                random.choice(vehicle_ids)  # vehicle_id assignment
            ))
            
        return orders
        
    def generate_deliveries(self, count: int) -> List[Tuple]:
        """Generate deliveries based on orders."""
        self.logger.info(f"🚚 Generating {count} deliveries...")
        
        connection = self.db.get_connection()
        cursor = connection.cursor()
        
        # Get orders với vehicle assignments
        cursor.execute("""
            SELECT id, created_at, vehicle_id, address_id, total_amount 
            FROM orders 
            WHERE vehicle_id IS NOT NULL 
            LIMIT %s
        """, (count,))
        orders = cursor.fetchall()
        
        cursor.close()
        connection.close()
        
        deliveries = []
        for order_id, order_date, vehicle_id, address_id, total_amount in orders:
            # Delivery fee calculation
            delivery_fee = round(random.uniform(15000, 50000), 2)
            
            # Pickup date (same day hoặc next day)
            pickup_date = order_date + timedelta(hours=random.randint(2, 24))
            
            # Delivery time calculation
            service_types = ['STANDARD', 'EXPRESS', 'SAME_DAY']
            service_type = str(np.random.choice(service_types, p=[0.6, 0.3, 0.1]))
            
            if service_type == 'SAME_DAY':
                delivery_hours = random.randint(2, 8)
            elif service_type == 'EXPRESS':
                delivery_hours = random.randint(12, 24)
            else:  # STANDARD
                delivery_hours = random.randint(24, 72)
                
            scheduled_delivery = pickup_date + timedelta(hours=delivery_hours)
            
            # Late delivery risk
            if random.random() < 0.15:  # 15% có risk
                late_delivery_risk = random.choice([1, 2])  # Medium, High
                actual_delay = random.randint(1, 48)  # hours
                actual_delivery = scheduled_delivery + timedelta(hours=actual_delay)
            else:
                late_delivery_risk = 0  # Low
                # Deliver on time hoặc sớm
                early_minutes = random.randint(-60, 30)
                actual_delivery = scheduled_delivery + timedelta(minutes=early_minutes)
                
            # Status for deliveries
            delivery_status = int(np.random.choice([1, 2, 3, 4], p=[0.1, 0.2, 0.6, 0.1]))  # pending, transit, delivered, failed
            
            deliveries.append((
                order_id,
                delivery_fee,
                'ROAD',  # transport_mode
                service_type,
                order_date,  # order_date (required)
                pickup_date,
                scheduled_delivery,  # schedule_delivery_time
                actual_delivery,
                late_delivery_risk,
                vehicle_id,
                None,  # driver_id
                None,  # tracking_id  
                None,  # route_id
                random.randint(1, 3) if random.random() < 0.1 else 1,  # delivery_attempts
                fake.sentence() if random.random() < 0.2 else None,  # delivery_notes
                datetime.now(),
                datetime.now()
            ))
            
        return deliveries
        
    def generate_delivery_tracking(self, count: int) -> List[Tuple]:
        """Generate GPS tracking data for deliveries."""
        self.logger.info(f"📍 Generating {count} delivery tracking records...")
        
        connection = self.db.get_connection()
        cursor = connection.cursor()
        
        cursor.execute("""
            SELECT d.id, d.vehicle_id, d.pickup_date, d.actual_delivery_time, 
                   COALESCE(a.latitude, 10.8231), COALESCE(a.longitude, 106.6297)
            FROM deliveries d
            JOIN orders o ON d.order_id = o.id
            LEFT JOIN addresses a ON o.address_id = a.id
            WHERE d.vehicle_id IS NOT NULL
            AND d.pickup_date IS NOT NULL 
            AND d.actual_delivery_time IS NOT NULL
            LIMIT %s
        """, (count // 5,))  # Mỗi delivery có ~5 tracking points
        
        deliveries = cursor.fetchall()
        cursor.close()
        connection.close()
        
        tracking_records = []
        for delivery_id, vehicle_id, pickup_date, delivery_date, dest_lat, dest_lng in deliveries:
            # Convert Decimal to float
            dest_lat = float(dest_lat)
            dest_lng = float(dest_lng)
            # Generate tracking points từ pickup đến delivery
            duration = (delivery_date - pickup_date).total_seconds() / 3600  # hours
            num_points = random.randint(3, 8)
            
            for i in range(num_points):
                # Time progression
                progress = i / (num_points - 1)
                tracking_time = pickup_date + timedelta(hours=duration * progress)
                
                # Location progression (simplified)
                if i == 0:
                    # Start from warehouse/store (random nearby point)
                    lat = dest_lat + random.uniform(-0.1, 0.1)
                    lng = dest_lng + random.uniform(-0.1, 0.1)
                elif i == num_points - 1:
                    # End at destination
                    lat = dest_lat + random.uniform(-0.001, 0.001)  # Very close
                    lng = dest_lng + random.uniform(-0.001, 0.001)
                else:
                    # Intermediate points
                    lat = dest_lat + random.uniform(-0.05, 0.05) * (1 - progress)
                    lng = dest_lng + random.uniform(-0.05, 0.05) * (1 - progress)
                
                # Status progression
                if i == 0:
                    status = 'PICKED_UP'
                elif i == num_points - 1:
                    status = 'DELIVERED'
                else:
                    status = 'IN_TRANSIT'
                    
                # Speed calculation (km/h)
                speed = random.uniform(20, 60) if status == 'IN_TRANSIT' else 0
                
                tracking_records.append((
                    vehicle_id,
                    1,  # status_id for tracking
                    round(lat, 8),  # DECIMAL(10,8)
                    round(lng, 8),  # DECIMAL(11,8)
                    tracking_time,  # timestamp
                    f"{status} - Speed: {speed:.1f}km/h",  # location
                    f"Tracking point {i+1} for delivery {delivery_id}",  # notes
                    datetime.now(),
                    datetime.now(),
                    delivery_id
                ))
                
        return tracking_records
        
    def generate_warehouses(self, count: int = 25) -> List[Tuple]:
        """Generate warehouses với Vietnamese locale và realistic business logic."""
        self.logger.info(f"🏭 Generating {count} warehouses...")
        
        warehouses = []
        warehouse_types = [
            {"type": "MAIN", "weight": 0.15, "capacity": (5000, 15000)},
            {"type": "REGIONAL", "weight": 0.25, "capacity": (1000, 5000)},
            {"type": "LOCAL", "weight": 0.35, "capacity": (200, 1000)},
            {"type": "DISTRIBUTION", "weight": 0.25, "capacity": (500, 2000)}
        ]
        
        for i in range(count):
            # Chọn city theo weight distribution
            city = np.random.choice(
                [c["name"] for c in self.config.major_cities],
                p=[c["weight"] for c in self.config.major_cities]
            )
            city_info = next(c for c in self.config.major_cities if c["name"] == city)
            lat, lng = self._get_random_coordinates(city_info)
            
            # Chọn warehouse type
            wh_type_info = np.random.choice(
                warehouse_types, 
                p=[wt["weight"] for wt in warehouse_types]
            )
            wh_type = wh_type_info["type"]
            capacity = random.randint(*wh_type_info["capacity"])
            
            warehouses.append((
                f"WH_{city.replace(' ', '').replace('.', '')}_{i+1:03d}",  # warehouse_code
                f"Kho {wh_type} {city} #{i+1}",  # name
                fake.address(),  # address
                lat, lng,  # coordinates
                capacity,  # capacity_m3
                1,  # is_active (ACTIVE)
                datetime.now(), datetime.now(),
                None,  # created_by
                f"Kho {wh_type} - Capacity: {capacity}m³"  # notes
            ))
            
        return warehouses
        
    def generate_stores(self, count: int = 150) -> List[Tuple]:
        """Generate stores với Vietnamese business patterns."""
        self.logger.info(f"🏪 Generating {count} stores...")
        
        stores = []
        store_types = ["FLAGSHIP", "STANDARD", "EXPRESS", "PICKUP_POINT"]
        
        for i in range(count):
            city = np.random.choice(
                [c["name"] for c in self.config.major_cities],
                p=[c["weight"] for c in self.config.major_cities]
            )
            city_info = next(c for c in self.config.major_cities if c["name"] == city)
            lat, lng = self._get_random_coordinates(city_info)
            
            store_type = random.choice(store_types)
            
            stores.append((
                None,  # external_id
                f"Cửa hàng {store_type} {city} #{i+1}",  # store_name
                fake.email(),  # email
                fake.phone_number(),  # phone
                fake.address(),  # address
                lat, lng,  # coordinates
                1,  # is_active
                datetime.now(), datetime.now(),
                None,  # created_by
                f"Loại cửa hàng: {store_type}"  # notes
            ))
            
        return stores
        
    def generate_routes(self, count: int = 100) -> List[Tuple]:
        """Generate delivery routes với realistic distance calculations."""
        self.logger.info(f"🛣️ Generating {count} routes...")
        
        routes = []
        cities = self.config.major_cities
        
        for i in range(count):
            # Chọn start và end cities
            start_city = random.choice(cities)
            end_cities = [c for c in cities if c != start_city]
            end_city = random.choice(end_cities)
            
            # Calculate realistic distance dựa trên coordinates
            start_point = Point(start_city["lat"], start_city["lng"])
            end_point = Point(end_city["lat"], end_city["lng"])
            straight_distance = geopy.distance.distance(start_point, end_point).kilometers
            
            # Add road factor (1.3-1.8x straight distance)
            road_factor = random.uniform(1.3, 1.8)
            estimated_distance = round(straight_distance * road_factor, 1)
            
            # Calculate duration based on distance và traffic
            if estimated_distance < 50:
                # City routes - heavy traffic
                avg_speed = random.uniform(25, 35)  # km/h
            elif estimated_distance < 200:
                # Regional routes
                avg_speed = random.uniform(45, 60)  # km/h  
            else:
                # Long distance routes
                avg_speed = random.uniform(60, 80)  # km/h
                
            estimated_duration = round(estimated_distance / avg_speed * 60)  # minutes
            
            # Generate waypoints
            waypoints = self._generate_waypoints(start_city, end_city, estimated_distance)
            
            route_name = f"{start_city['name']} → {end_city['name']} (Tuyến {i+1})"
            
            # Calculate estimated cost based on distance
            estimated_cost = estimated_distance * random.uniform(15000, 25000)  # VND per km
            
            routes.append((
                route_name,  # name
                json.dumps(waypoints, ensure_ascii=False),  # waypoints (JSON)
                estimated_distance,  # estimated_distance_km
                estimated_duration,  # estimated_duration_minutes
                round(estimated_cost, 2),  # estimated_cost
                datetime.now(), datetime.now(),  # created_at, updated_at
                None,  # completed_at
                None,  # created_by
                f"Tuyến đường {estimated_distance}km - Thời gian ước tính: {estimated_duration} phút"  # notes
            ))
            
        return routes
        
    def _generate_waypoints(self, start_city: Dict, end_city: Dict, distance_km: float) -> List[Dict]:
        """Generate realistic waypoints for route."""
        waypoints = []
        
        # Start point
        waypoints.append({
            "lat": start_city["lat"],
            "lng": start_city["lng"], 
            "name": f"Khởi hành - {start_city['name']}",
            "type": "START"
        })
        
        # Intermediate waypoints based on distance
        num_waypoints = min(int(distance_km / 100), 5)  # Max 5 waypoints
        
        for i in range(num_waypoints):
            progress = (i + 1) / (num_waypoints + 1)
            lat = start_city["lat"] + (end_city["lat"] - start_city["lat"]) * progress
            lng = start_city["lng"] + (end_city["lng"] - start_city["lng"]) * progress
            
            # Add realistic noise
            lat += random.uniform(-0.05, 0.05)
            lng += random.uniform(-0.05, 0.05)
            
            waypoints.append({
                "lat": round(lat, 6),
                "lng": round(lng, 6),
                "name": f"Điểm dừng {i+1}",
                "type": "WAYPOINT"
            })
        
        # End point
        waypoints.append({
            "lat": end_city["lat"],
            "lng": end_city["lng"],
            "name": f"Đích đến - {end_city['name']}",
            "type": "END"
        })
        
        return waypoints
        
    def generate_warehouse_transactions(self, count: int = 30000) -> List[Tuple]:
        """Generate warehouse transactions với comprehensive business logic."""
        self.logger.info(f"📦 Generating {count} warehouse transactions...")
        
        # Load dependencies
        connection = self.db.get_connection()
        cursor = connection.cursor()
        
        # Get products với category info
        cursor.execute("""
            SELECT p.id, p.name, p.unit_price, c.name as category_name
            FROM products p 
            JOIN categories c ON p.category_id = c.id
        """)
        products = [{"id": row[0], "name": row[1], "unit_price": float(row[2]), "category": row[3]} 
                   for row in cursor.fetchall()]
        
        cursor.execute("SELECT id FROM warehouses")
        warehouse_ids = [row[0] for row in cursor.fetchall()]
        
        cursor.execute("SELECT id, created_at FROM orders WHERE id <= 1000")  # Sample orders
        orders = [{"id": row[0], "created_at": row[1]} for row in cursor.fetchall()]
        
        cursor.execute("SELECT id FROM users WHERE role_id = (SELECT id FROM roles WHERE role_name = 'WAREHOUSE_STAFF' LIMIT 1)")
        warehouse_staff = [row[0] for row in cursor.fetchall()]
        if not warehouse_staff:
            cursor.execute("SELECT id FROM users LIMIT 10")  # Fallback
            warehouse_staff = [row[0] for row in cursor.fetchall()]
            
        cursor.close()
        connection.close()
        
        if not products or not warehouse_ids:
            raise ValueError("❌ Missing products or warehouses for transaction generation")
            
        transactions = []
        
        # 1. INITIAL STOCK (IN transactions) - 40%
        self.logger.info("📥 Generating initial stock transactions...")
        for _ in tqdm(range(int(count * 0.4)), desc="Stock IN"):
            product = random.choice(products)
            warehouse_id = random.choice(warehouse_ids)
            
            # Stock levels based on product category và price
            if product['unit_price'] > 500000:  # High-value items
                quantity = random.randint(10, 100)
                unit_cost = product['unit_price'] * random.uniform(0.6, 0.8)  # 60-80% of selling price
            elif product['unit_price'] > 100000:  # Medium-value items
                quantity = random.randint(50, 300)
                unit_cost = product['unit_price'] * random.uniform(0.65, 0.85)
            else:  # Low-value items
                quantity = random.randint(100, 1000)
                unit_cost = product['unit_price'] * random.uniform(0.7, 0.9)
                
            # Historical dates (last 6 months, weighted towards recent)
            days_ago = int(np.random.exponential(30))  # Exponential distribution
            days_ago = min(days_ago, 180)  # Cap at 6 months
            transaction_date = datetime.now() - timedelta(days=days_ago)
            
            transactions.append((
                product['id'],  # product_id
                warehouse_id,   # warehouse_id
                1,  # status_id (COMPLETED)
                'IN',  # transaction_type
                quantity,  # quantity
                round(unit_cost, 2),  # unit_cost
                transaction_date,  # transaction_date
                None,  # order_id (NULL for stock-in)
                datetime.now(),  # created_at
                random.choice(warehouse_staff) if warehouse_staff else None,  # created_by
                f"Nhập kho ban đầu - {product['name']}"  # notes
            ))
        
        # 2. ORDER FULFILLMENT (OUT transactions) - 50%
        self.logger.info("📤 Generating order fulfillment transactions...")
        for _ in tqdm(range(int(count * 0.5)), desc="Order OUT"):
            product = random.choice(products)
            warehouse_id = random.choice(warehouse_ids)
            
            # Fulfillment quantity (realistic order sizes)
            if product['unit_price'] > 500000:  # Expensive items
                quantity = random.randint(1, 3)
            elif product['unit_price'] > 100000:
                quantity = random.randint(1, 5)
            else:
                quantity = random.randint(1, 10)
                
            # Cost calculation
            unit_cost = product['unit_price'] * random.uniform(0.6, 0.8)
            
            # Transaction date (recent orders)
            if orders and random.random() < 0.7:  # 70% linked to actual orders
                order = random.choice(orders)
                order_id = order['id']
                # Transaction 1-48 hours after order
                min_date = order['created_at'] + timedelta(hours=1)
                max_date = order['created_at'] + timedelta(hours=48)
                transaction_date = fake.date_time_between(start_date=min_date, end_date=max_date)
            else:
                order_id = None
                transaction_date = fake.date_time_between(start_date='-90d')
                
            transactions.append((
                product['id'], warehouse_id, 1, 'OUT', quantity,
                round(unit_cost, 2), transaction_date, order_id,
                datetime.now(), random.choice(warehouse_staff) if warehouse_staff else None,
                f"Xuất kho đơn hàng - {product['name']}"
            ))
        
        # 3. INTER-WAREHOUSE TRANSFERS - 10%
        self.logger.info("🔄 Generating transfer transactions...")
        for _ in tqdm(range(int(count * 0.1)), desc="Transfers"):
            product = random.choice(products)
            from_warehouse = random.choice(warehouse_ids)
            to_warehouse = random.choice([w for w in warehouse_ids if w != from_warehouse])
            
            quantity = random.randint(5, 100)
            unit_cost = product['unit_price'] * random.uniform(0.65, 0.85)
            transaction_date = fake.date_time_between(start_date='-120d')
            
            # OUT transaction from source
            transactions.append((
                product['id'], from_warehouse, 1, 'TRANSFER_OUT',
                quantity, round(unit_cost, 2), transaction_date, None,
                datetime.now(), random.choice(warehouse_staff) if warehouse_staff else None,
                f"Chuyển kho đến WH-{to_warehouse} - {product['name']}"
            ))
            
            # IN transaction to destination (2-24 hours later)
            arrival_date = transaction_date + timedelta(hours=random.randint(2, 24))
            transactions.append((
                product['id'], to_warehouse, 1, 'TRANSFER_IN',
                quantity, round(unit_cost, 2), arrival_date, None,
                datetime.now(), random.choice(warehouse_staff) if warehouse_staff else None,
                f"Nhận chuyển kho từ WH-{from_warehouse} - {product['name']}"
            ))
            
        return transactions
        
    def generate_delivery_proofs(self, count: int = 15000) -> List[Tuple]:
        """Generate delivery proofs cho delivered orders."""
        self.logger.info(f"📸 Generating {count} delivery proofs...")
        
        # Get delivered orders
        connection = self.db.get_connection()
        cursor = connection.cursor()
        
        cursor.execute("""
            SELECT o.id, o.external_id, d.actual_delivery_time
            FROM orders o
            JOIN deliveries d ON o.id = d.order_id
            WHERE d.actual_delivery_time IS NOT NULL
            AND d.actual_delivery_time <= NOW()  -- Already delivered
            AND o.status_id IN (4, 5)  -- DELIVERED or COMPLETED status in orders
            ORDER BY d.actual_delivery_time DESC
            LIMIT %s
        """, (count,))
        delivered_orders = cursor.fetchall()
        
        cursor.execute("SELECT id FROM users WHERE role_id = (SELECT id FROM roles WHERE role_name = 'DRIVER' LIMIT 1)")
        drivers = [row[0] for row in cursor.fetchall()]
        if not drivers:
            cursor.execute("SELECT id FROM users LIMIT 20")  # Fallback
            drivers = [row[0] for row in cursor.fetchall()]
            
        cursor.close()
        connection.close()
        
        if not delivered_orders:
            self.logger.warning("⚠️ No delivered orders found for proof generation")
            return []
            
        proofs = []
        
        for order_id, external_id, delivery_time in tqdm(delivered_orders, desc="Delivery Proofs"):
            # Proof type distribution theo Vietnamese logistics patterns
            proof_type = np.random.choice(
                ['PHOTO', 'SIGNATURE', 'SMS_CONFIRMATION', 'PHONE_CONFIRMATION'],
                p=[0.5, 0.25, 0.15, 0.1]  # 50% photo, 25% signature, 15% SMS, 10% phone
            )
            
            # Generate realistic Vietnamese names
            recipient_name = fake.name()
            
            # File paths và names
            if proof_type == 'PHOTO':
                file_path = f"/storage/delivery_proofs/{order_id}"
                file_name = f"giao_hang_{external_id}_{uuid.uuid4().hex[:8]}.jpg"
                recipient_signature = None
            elif proof_type == 'SIGNATURE':
                file_path = f"/storage/signatures/{order_id}"
                file_name = f"chu_ky_{external_id}_{uuid.uuid4().hex[:8]}.png"
                recipient_signature = f"signature_{uuid.uuid4().hex[:12]}.png"
            else:  # SMS or PHONE confirmation
                file_path = None
                file_name = None
                recipient_signature = None
                
            # Captured time logic - within 30 minutes of delivery
            if delivery_time:
                time_variance = random.randint(-30, 30)  # +/- 30 minutes
                captured_at = delivery_time + timedelta(minutes=time_variance)
            else:
                captured_at = fake.date_time_between(start_date='-60d')
                
            # Vietnamese-style notes
            notes_options = [
                f"Đã giao hàng thành công cho {recipient_name}",
                f"Khách hàng {recipient_name} đã nhận hàng",
                f"Giao hàng tại địa chỉ, người nhận: {recipient_name}",
                f"Xác nhận giao hàng - {proof_type.lower()}"
            ]
            
            proofs.append((
                proof_type,  # proof_type
                file_path,   # file_path
                file_name,   # file_name
                recipient_name,  # recipient_name
                recipient_signature,  # recipient_signature
                captured_at,  # captured_at
                datetime.now(),  # created_at
                order_id,    # order_id
                random.choice(drivers) if drivers else None,  # uploaded_by
                random.choice(notes_options)  # notes
            ))
            
        return proofs

    def run_generation(self, phase: str = "all"):
        """Main generation method."""
        self.logger.info("🚀 Starting FastRoute data generation...")
        
        try:
            self._load_cache()
            
            if phase in ["all", "master"]:
                self.logger.info("📋 Phase 1: Master Data Generation")
                
                # Generate addresses
                if len(self.cache['addresses']) < self.config.addresses_count:
                    addresses_data = self.generate_addresses(self.config.addresses_count)
                    sql = """INSERT INTO addresses 
                            (address_type, address, city, country, region, postal_code, 
                             latitude, longitude, contact_name, contact_email, contact_phone, created_at)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                    self.db.execute_batch(sql, addresses_data)
                    
                # Generate warehouses
                if len(self.cache['warehouses']) < self.config.warehouses_count:
                    warehouses_data = self.generate_warehouses(self.config.warehouses_count)
                    sql = """INSERT INTO warehouses 
                            (warehouse_code, name, address, latitude, longitude, capacity_m3, 
                             is_active, created_at, updated_at, created_by, notes)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                    self.db.execute_batch(sql, warehouses_data)
                    
                # Generate stores
                if len(self.cache['stores']) < self.config.stores_count:
                    stores_data = self.generate_stores(self.config.stores_count)
                    sql = """INSERT INTO stores 
                            (external_id, store_name, email, phone, address, latitude, longitude, 
                             is_active, created_at, updated_at, created_by, notes)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                    self.db.execute_batch(sql, stores_data)
                    
                # Generate routes
                if len(self.cache.get('routes', [])) < self.config.routes_count:
                    routes_data = self.generate_routes(self.config.routes_count)
                    sql = """INSERT INTO routes 
                            (name, waypoints, estimated_distance_km, estimated_duration_minutes, 
                             estimated_cost, created_at, updated_at, completed_at, created_by, notes)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                    self.db.execute_batch(sql, routes_data)
                    
                # Generate users
                if len(self.cache['users']) < self.config.users_count:
                    users_data = self.generate_users(self.config.users_count)
                    sql = """INSERT INTO users 
                            (username, email, full_name, role_id, status_id, phone, created_at, updated_at)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"""
                    self.db.execute_batch(sql, users_data)
                    
                # Generate vehicles
                if len(self.cache['vehicles']) < self.config.vehicles_count:
                    vehicles_data = self.generate_vehicles(self.config.vehicles_count)
                    sql = """INSERT INTO vehicles 
                            (license_plate, vehicle_type, capacity_weight_kg, capacity_volume_m3, 
                             status_id, created_at, updated_at)
                            VALUES (%s, %s, %s, %s, %s, %s, %s)"""
                    self.db.execute_batch(sql, vehicles_data)
                    
            if phase in ["all", "transactional"]:
                self.logger.info("📦 Phase 2: Transactional Data Generation")
                
                # Generate orders với vehicle assignments
                orders_data = self.generate_orders_with_vehicles(self.config.orders_count)
                sql = """INSERT INTO orders 
                        (external_id, status_id, store_id, description, total_amount, 
                         benefit_per_order, order_profit_per_order, notes, created_at, 
                         updated_at, created_by, address_id, vehicle_id)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                self.db.execute_batch(sql, orders_data)
                
                # Generate deliveries
                deliveries_data = self.generate_deliveries(self.config.orders_count)
                sql = """INSERT INTO deliveries 
                        (order_id, delivery_fee, transport_mode, service_type, order_date,
                         pickup_date, schedule_delivery_time, actual_delivery_time, 
                         late_delivery_risk, vehicle_id, driver_id, tracking_id, route_id,
                         delivery_attempts, delivery_notes, created_at, updated_at)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                self.db.execute_batch(sql, deliveries_data)
                
            if phase in ["all", "operational"]:
                self.logger.info("📍 Phase 3: Operational Data Generation")
                
                # Generate delivery tracking
                tracking_data = self.generate_delivery_tracking(self.config.delivery_tracking_records)
                sql = """INSERT INTO delivery_tracking 
                        (vehicle_id, status_id, latitude, longitude, timestamp, 
                         location, notes, created_at, updated_at, delivery_id)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                self.db.execute_batch(sql, tracking_data)
                
            if phase in ["all", "warehouse_transactions"]:
                self.logger.info("📦 Phase 4: Warehouse Transactions Generation")
                
                # Generate warehouse transactions
                transactions_data = self.generate_warehouse_transactions(self.config.warehouse_transactions_count)
                sql = """INSERT INTO warehouse_transactions 
                        (product_id, warehouse_id, status_id, transaction_type, quantity, 
                         unit_cost, transaction_date, order_id, created_at, created_by, notes)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                self.db.execute_batch(sql, transactions_data)
                
            if phase in ["all", "delivery_proofs"]:
                self.logger.info("📸 Phase 5: Delivery Proofs Generation")
                
                # Generate delivery proofs
                proofs_data = self.generate_delivery_proofs(15000)
                sql = """INSERT INTO delivery_proofs 
                        (proof_type, file_path, file_name, recipient_name, recipient_signature, 
                         captured_at, created_at, order_id, uploaded_by, notes)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                self.db.execute_batch(sql, proofs_data)
                
            self.logger.info("🎉 Data generation completed successfully!")
            
        except Exception as e:
            self.logger.error(f"💥 Data generation failed: {e}")
            raise

def main():
    """Main function."""
    # Production database config
    DB_CONFIG = {
        'host': 'server.aptech.io',
        'user': 'fastroute_user',
        'password': 'fastroute_password',
        'database': 'fastroute_test',
        'port': 3307,
        'charset': 'utf8mb4',
        'raise_on_warnings': True
    }
    
    # Generation config
    config = GenerationConfig(scale="medium")
    
    # Create generator
    generator = FastRouteDataGenerator(DB_CONFIG, config)
    
    # Run generation
    import argparse
    parser = argparse.ArgumentParser(description='FastRoute Data Generator')
    parser.add_argument('--phase', choices=['master', 'transactional', 'operational', 
                                          'warehouse_transactions', 'delivery_proofs', 'all'], 
                       default='all', help='Generation phase')
    parser.add_argument('--scale', choices=['small', 'medium', 'large'], 
                       default='medium', help='Data scale')
    
    args = parser.parse_args()
    config.scale = args.scale
    config.__post_init__()  # Recalculate counts
    
    try:
        generator.run_generation(args.phase)
        print("✅ FastRoute data generation completed successfully!")
    except Exception as e:
        print(f"❌ Generation failed: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
