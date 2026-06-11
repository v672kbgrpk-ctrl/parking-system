-- ============================================
-- 车位热度分析菜单修复脚本
-- ============================================

-- 1. 检查父菜单（停车场管理）是否存在
SELECT '=== 父菜单信息 ===' AS info;
SELECT menu_id, parent_id, name, type, order_num 
FROM sys_menu 
WHERE menu_id = 295;

-- 2. 检查当前停车场管理下的所有子菜单
SELECT '=== 停车场管理的子菜单 ===' AS info;
SELECT menu_id, parent_id, name, url, type, icon, order_num 
FROM sys_menu 
WHERE parent_id = 295 
ORDER BY order_num;

-- 3. 检查是否存在车位热度分析菜单
SELECT '=== 检查车位热度分析菜单 ===' AS info;
SELECT menu_id, parent_id, name, url, type, icon, order_num 
FROM sys_menu 
WHERE name = '车位热度分析';

-- 4. 如果不存在，添加车位热度分析菜单
-- 注意：如果 menu_id=317 已存在，请改用 318、319 等
INSERT INTO `sys_menu` VALUES (
    317,              -- menu_id
    295,              -- parent_id (停车场管理)
    '车位热度分析',    -- name
    'car/parkHeat/statistics.html',  -- url
    NULL,             -- perms
    1,                -- type (1=菜单)
    'layui-icon layui-icon-chart',   -- icon
    2,                -- order_num (排序)
    NOW(),            -- gmt_create
    NOW()             -- gmt_modified
)
ON DUPLICATE KEY UPDATE 
    name = '车位热度分析',
    url = 'car/parkHeat/statistics.html',
    type = 1,
    icon = 'layui-icon layui-icon-chart',
    order_num = 2,
    gmt_modified = NOW();

-- 5. 验证添加结果
SELECT '=== 添加后的子菜单列表 ===' AS info;
SELECT menu_id, parent_id, name, url, type, icon, order_num 
FROM sys_menu 
WHERE parent_id = 295 
ORDER BY order_num;

-- 6. 检查当前用户的角色分配（用于诊断）
SELECT '=== 用户角色分配 ===' AS info;
SELECT u.user_id, u.username, r.role_id, r.name AS role_name
FROM sys_user u
LEFT JOIN sys_user_role ur ON u.user_id = ur.user_id
LEFT JOIN sys_role r ON ur.role_id = r.role_id
WHERE u.username = 'admin';  -- 假设您使用 admin 账号登录

-- 7. 检查角色菜单权限（确保角色有停车场管理的权限）
SELECT '=== 角色菜单权限 ===' AS info;
SELECT r.role_id, r.name AS role_name, m.menu_id, m.name AS menu_name
FROM sys_role r
LEFT JOIN sys_role_menu rm ON r.role_id = rm.role_id
LEFT JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.role_id IN (
    SELECT role_id FROM sys_user_role WHERE user_id = (
        SELECT user_id FROM sys_user WHERE username = 'admin'
    )
)
AND m.parent_id = 295
ORDER BY r.role_id, m.order_num;

-- 8. 如果角色没有车位热度分析的权限，添加权限
-- 首先找到 admin 用户的角色 ID
SET @admin_role_id = (
    SELECT role_id FROM sys_user_role 
    WHERE user_id = (SELECT user_id FROM sys_user WHERE username = 'admin')
    LIMIT 1
);

-- 检查是否已存在权限
SELECT CONCAT('=== 角色 ID ', @admin_role_id, ' 的菜单权限 ===') AS info;

-- 添加菜单权限（如果不存在）
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT @admin_role_id, 317
WHERE NOT EXISTS (
    SELECT 1 FROM sys_role_menu WHERE role_id = @admin_role_id AND menu_id = 317
);

-- 9. 最终验证
SELECT '=== 最终验证：角色菜单权限 ===' AS info;
SELECT r.name AS role_name, m.name AS menu_name, m.url, m.icon
FROM sys_role r
JOIN sys_role_menu rm ON r.role_id = rm.role_id
JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.role_id = @admin_role_id
AND m.parent_id = 295
ORDER BY m.order_num;
