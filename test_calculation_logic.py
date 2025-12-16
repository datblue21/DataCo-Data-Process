#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script test nhanh logic tính toán phí giao hàng
Tác giả: DataCo Team
Ngày tạo: 2025-01-11
"""

from decimal import Decimal, ROUND_HALF_UP

def test_shipping_fee_calculation():
    """Test logic tính toán shipping_fee"""
    
    print("🧮 === TEST LOGIC TÍNH TOÁN PHÍ GIAO HÀNG ===\n")
    
    # Hằng số
    BASE_PRICE_PER_KG = Decimal('15000')
    VOLUME_TO_WEIGHT_FACTOR = Decimal('200')
    
    # Hệ số
    SERVICE_TYPE_MULTIPLIERS = {
        'SECOND_CLASS': Decimal('0.8'),
        'STANDARD': Decimal('1.0'),
        'FIRST_CLASS': Decimal('1.3'),
        'EXPRESS': Decimal('1.8')
    }
    
    FRAGILE_MULTIPLIER = Decimal('1.3')
    NORMAL_MULTIPLIER = Decimal('1.0')
    
    def calculate_shipping_fee(weight, volume, is_fragile, service_type):
        """Tính shipping_fee"""
        weight = Decimal(str(weight))
        volume = Decimal(str(volume))
        
        # 1. Trọng lượng tính phí
        volume_weight = volume * VOLUME_TO_WEIGHT_FACTOR
        shipping_weight = max(weight, volume_weight)
        
        # 2. Phí cơ bản
        base_fee = shipping_weight * BASE_PRICE_PER_KG
        
        # 3. Hệ số rủi ro
        fragile_multiplier = FRAGILE_MULTIPLIER if is_fragile else NORMAL_MULTIPLIER
        
        # 4. Hệ số service type
        service_multiplier = SERVICE_TYPE_MULTIPLIERS.get(service_type, Decimal('1.0'))
        
        # 5. Tổng phí
        total_fee = base_fee * fragile_multiplier * service_multiplier
        total_fee = total_fee.quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)
        
        return total_fee, shipping_weight, base_fee
    
    # Test cases
    test_cases = [
        {
            'name': 'Sản phẩm nhẹ, thể tích lớn',
            'weight': 10,
            'volume': 0.5,
            'is_fragile': False,
            'service_type': 'STANDARD'
        },
        {
            'name': 'Sản phẩm nặng, thể tích nhỏ',
            'weight': 150,
            'volume': 0.1,
            'is_fragile': False,
            'service_type': 'STANDARD'
        },
        {
            'name': 'Sản phẩm dễ vỡ, EXPRESS',
            'weight': 50,
            'volume': 0.2,
            'is_fragile': True,
            'service_type': 'EXPRESS'
        },
        {
            'name': 'Field & Stream Safe (như trong DB)',
            'weight': 150,
            'volume': 1.2,
            'is_fragile': False,
            'service_type': 'STANDARD'
        },
        {
            'name': 'Field & Stream Safe - EXPRESS',
            'weight': 150,
            'volume': 1.2,
            'is_fragile': False,
            'service_type': 'EXPRESS'
        },
        {
            'name': 'Field & Stream Safe - SECOND_CLASS',
            'weight': 150,
            'volume': 1.2,
            'is_fragile': False,
            'service_type': 'SECOND_CLASS'
        }
    ]
    
    for i, case in enumerate(test_cases, 1):
        print(f"📦 Test Case {i}: {case['name']}")
        print(f"   Input: {case['weight']}kg, {case['volume']}m³, Fragile: {case['is_fragile']}, Service: {case['service_type']}")
        
        shipping_fee, shipping_weight, base_fee = calculate_shipping_fee(
            case['weight'], case['volume'], case['is_fragile'], case['service_type']
        )
        
        volume_weight = Decimal(str(case['volume'])) * VOLUME_TO_WEIGHT_FACTOR
        
        print(f"   Trọng lượng thực tế: {case['weight']}kg")
        print(f"   Trọng lượng quy đổi: {volume_weight}kg")
        print(f"   Trọng lượng tính phí: {shipping_weight}kg")
        print(f"   Phí cơ bản: {base_fee:,} VNĐ")
        print(f"   Hệ số rủi ro: {FRAGILE_MULTIPLIER if case['is_fragile'] else NORMAL_MULTIPLIER}")
        print(f"   Hệ số service: {SERVICE_TYPE_MULTIPLIERS[case['service_type']]}")
        print(f"   ➡️  Shipping Fee: {shipping_fee:,} VNĐ")
        print()
    
    # Test delivery_fee calculation
    print("🚚 === TEST DELIVERY FEE CALCULATION ===\n")
    
    # Giả lập 1 order có nhiều items
    order_items = [
        {'shipping_fee': Decimal('3600000.00')},  # Item 1
        {'shipping_fee': Decimal('1800000.00')},  # Item 2  
        {'shipping_fee': Decimal('900000.00')},   # Item 3
    ]
    
    delivery_fee = sum(item['shipping_fee'] for item in order_items)
    
    print(f"📋 Order với {len(order_items)} items:")
    for i, item in enumerate(order_items, 1):
        print(f"   Item {i}: {item['shipping_fee']:,} VNĐ")
    print(f"   ➡️  Delivery Fee: {delivery_fee:,} VNĐ")
    print()
    
    print("✅ === TẤT CẢ TEST CASES HOÀN THÀNH ===")

if __name__ == "__main__":
    test_shipping_fee_calculation()




