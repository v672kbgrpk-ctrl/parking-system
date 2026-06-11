-- ============================================
-- 修复角色菜单权限
-- ============================================

-- 1. 查看所有用户
SELECT '=== 所有用户 ===' AS info;
SELECT user_id, username, status FROM sys_user;

-- 2. 查看所有角色
SELECT '=== 所有角色 ===' AS info;
SELECT role_id, name, description FROM sys_role;

-- 3. 查看用户角色关系
SELECT '=== 用户角色关系 ===' AS info;
SELECT u.username, ur.role_id, r.name AS role_name
FROM sys_user u
LEFT JOIN sys_user_role ur ON u.user_id = ur.user_id
LEFT JOIN sys_role r ON ur.role_id = r.role_id;

-- 4. 查看管理员角色的所有菜单权限
SELECT '=== 管理员角色的菜单权限 ===' AS info;
SELECT r.name AS role_name, m.menu_id, m.name AS menu_name, m.url
FROM sys_role r
LEFT JOIN sys_role_menu rm ON r.role_id = rm.role_id
LEFT JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.name LIKE '%admin%' OR r.name LIKE '%管理员%'
ORDER BY m.parent_id, m.order_num;

-- 5. 获取管理员角色 ID
SET @admin_role_id = (
    SELECT role_id FROM sys_role 
    WHERE name LIKE '%admin%' OR name LIKE '%管理员%'
    LIMIT 1
);

SELECT CONCAT('=== 管理员角色 ID: ', @admin_role_id, ' ===') AS info;

-- 6. 给管理员角色添加车位热度分析菜单权限（317, 318, 319）
-- 添加 menu_id=317
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT @admin_role_id, 317
WHERE NOT EXISTS (
    SELECT 1 FROM sys_role_menu WHERE role_id = @admin_role_id AND menu_id = 317
);

-- 添加 menu_id=318（如果存在）
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT @admin_role_id, 318
WHERE NOT EXISTS (
    SELECT 1 FROM sys_role_menu WHERE role_id = @admin_role_id AND menu_id = 318
);

-- 添加 menu_id=319（如果存在）
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT @admin_role_id, 319
WHERE NOT EXISTS (
    SELECT 1 FROM sys_role_menu WHERE role_id = @admin_role_id AND menu_id = 319
);

-- 7. 验证权限是否添加成功
SELECT '=== 添加后的权限 ===' AS info;
SELECT r.name AS role_name, m.name AS menu_name, m.url
FROM sys_role r
JOIN sys_role_menu rm ON r.role_id = rm.role_id
JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.role_id = @admin_role_id
AND m.parent_id = 295  -- 停车场管理下的菜单
ORDER BY m.order_num;
