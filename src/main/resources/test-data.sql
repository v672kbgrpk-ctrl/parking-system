-- 智慧停车管理系统测试数据
-- 请根据实际情况修改数据

-- 1. 添加停车场数据
INSERT INTO app_car_park_manage (name, org_id, org_name, status, parking_space_number, free_time, time_unit, unit_cost, max_money, gmt_create, user_id_create)
VALUES 
('地下停车场', 1, '总部', 1, 100, 30, 60, 5.00, 50.00, NOW(), 1),
('地面停车场', 1, '总部', 1, 80, 15, 60, 3.00, 30.00, NOW(), 1),
('VIP停车场', 1, '总部', 1, 50, 60, 60, 8.00, 80.00, NOW(), 1);

-- 2. 添加停车记录数据（今日数据）
INSERT INTO app_car_parking_record (order_no, org_id, org_name, park_manage_id, park_manage_name, plate_number, type, gmt_into, gmt_out, cost)
VALUES 
-- 今日入场记录
('ORD202606090001', 1, '总部', 1, '地下停车场', '京A12345', 0, NOW(), NULL, NULL),
('ORD202606090002', 1, '总部', 1, '地下停车场', '京B67890', 1, DATE_SUB(NOW(), INTERVAL 2 HOUR), NULL, NULL),
('ORD202606090003', 1, '总部', 2, '地面停车场', '京C11111', 2, DATE_SUB(NOW(), INTERVAL 1 HOUR), NULL, NULL),
('ORD202606090004', 1, '总部', 3, 'VIP停车场', '京D22222', 1, NOW(), NULL, NULL),
-- 今日出场记录
('ORD202606090005', 1, '总部', 1, '地下停车场', '京E33333', 2, DATE_SUB(NOW(), INTERVAL 5 HOUR), NOW(), 15.00),
('ORD202606090006', 1, '总部', 2, '地面停车场', '京F44444', 0, DATE_SUB(NOW(), INTERVAL 3 HOUR), DATE_SUB(NOW(), INTERVAL 1 HOUR), 10.00),
('ORD202606090007', 1, '总部', 1, '地下停车场', '京G55555', 2, DATE_SUB(NOW(), INTERVAL 4 HOUR), DATE_SUB(NOW(), INTERVAL 30 MINUTE), 20.00),
('ORD202606090008', 1, '总部', 3, 'VIP停车场', '京H66666', 1, DATE_SUB(NOW(), INTERVAL 6 HOUR), DATE_SUB(NOW(), INTERVAL 2 HOUR), 0.00);

-- 3. 添加历史停车记录（最近7天）
INSERT INTO app_car_parking_record (order_no, org_id, org_name, park_manage_id, park_manage_name, plate_number, type, gmt_into, gmt_out, cost)
VALUES 
-- 6月8日
('ORD202606080001', 1, '总部', 1, '地下停车场', '京A11111', 2, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY) + INTERVAL 2 HOUR, 10.00),
('ORD202606080002', 1, '总部', 2, '地面停车场', '京B22222', 0, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY) + INTERVAL 3 HOUR, 15.00),
-- 6月7日
('ORD202606070001', 1, '总部', 1, '地下停车场', '京C33333', 1, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY) + INTERVAL 1 HOUR, 5.00),
('ORD202606070002', 1, '总部', 3, 'VIP停车场', '京D44444', 2, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY) + INTERVAL 4 HOUR, 20.00),
-- 6月6日
('ORD202606060001', 1, '总部', 2, '地面停车场', '京E55555', 0, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY) + INTERVAL 2 HOUR, 12.00),
-- 6月5日
('ORD202606050001', 1, '总部', 1, '地下停车场', '京F66666', 2, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY) + INTERVAL 3 HOUR, 18.00),
-- 6月4日
('ORD202606040001', 1, '总部', 3, 'VIP停车场', '京G77777', 1, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY) + INTERVAL 2 HOUR, 8.00),
-- 6月3日
('ORD202606030001', 1, '总部', 2, '地面停车场', '京H88888', 0, DATE_SUB(NOW(), INTERVAL 6 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY) + INTERVAL 1 HOUR, 6.00);

-- 4. 添加订单数据（今日）
INSERT INTO app_order (body, order_no, total_fee, type, gmt_create, user_create, park_manage_id, org_id, plate_number, status)
VALUES 
('停车费用', 'ORD202606090005', 15.00, 0, NOW(), 1, 1, 1, '京E33333', 1),
('停车费用', 'ORD202606090006', 10.00, 1, NOW(), 1, 2, 1, '京F44444', 1),
('停车费用', 'ORD202606090007', 20.00, 2, NOW(), 1, 1, 1, '京G55555', 1),
('停车费用', 'ORD202606090008', 0.00, 3, NOW(), 1, 3, 1, '京H66666', 1);

-- 5. 添加历史订单数据（最近7天）
INSERT INTO app_order (body, order_no, total_fee, type, gmt_create, user_create, park_manage_id, org_id, plate_number, status)
VALUES 
('停车费用', 'ORD202606080001', 10.00, 0, DATE_SUB(NOW(), INTERVAL 1 DAY), 1, 1, 1, '京A11111', 1),
('停车费用', 'ORD202606080002', 15.00, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 1, 2, 1, '京B22222', 1),
('停车费用', 'ORD202606070001', 5.00, 2, DATE_SUB(NOW(), INTERVAL 2 DAY), 1, 1, 1, '京C33333', 1),
('停车费用', 'ORD202606070002', 20.00, 3, DATE_SUB(NOW(), INTERVAL 2 DAY), 1, 3, 1, '京D44444', 1),
('停车费用', 'ORD202606060001', 12.00, 0, DATE_SUB(NOW(), INTERVAL 3 DAY), 1, 2, 1, '京E55555', 1),
('停车费用', 'ORD202606050001', 18.00, 1, DATE_SUB(NOW(), INTERVAL 4 DAY), 1, 1, 1, '京F66666', 1),
('停车费用', 'ORD202606040001', 8.00, 2, DATE_SUB(NOW(), INTERVAL 5 DAY), 1, 3, 1, '京G77777', 1),
('停车费用', 'ORD202606030001', 6.00, 3, DATE_SUB(NOW(), INTERVAL 6 DAY), 1, 2, 1, '京H88888', 1);

-- 查询验证
SELECT '停车场数量' as item, COUNT(*) as value FROM app_car_park_manage
UNION ALL
SELECT '今日入场', COUNT(*) FROM app_car_parking_record WHERE DATE(gmt_into) = CURDATE()
UNION ALL
SELECT '今日出场', COUNT(*) FROM app_car_parking_record WHERE DATE(gmt_out) = CURDATE()
UNION ALL
SELECT '今日收入', COALESCE(SUM(cost), 0) FROM app_car_parking_record WHERE DATE(gmt_out) = CURDATE();
