-- ============================================
-- 直接添加车位热度分析菜单权限
-- ============================================

-- 查看所有角色（找管理员角色 ID）
SELECT '=== 所有角色 ===' AS info;
SELECT * FROM sys_role;

-- 查看用户角色关系（找 admin 用户的角色）
SELECT '=== 用户角色关系 ===' AS info;
SELECT * FROM sys_user_role;

-- 查看现有角色菜单权限（找停车场管理的权限）
SELECT '=== 停车场管理的权限 ===' AS info;
SELECT * FROM sys_role_menu WHERE menu_id = 295 OR menu_id = 296;

-- ==============================
-- 手动输入角色 ID 和菜单 ID 后执行下面的 INSERT
-- ==============================

-- 示例：假设管理员角色 ID 是 1，给它添加车位热度分析菜单权限
-- INSERT INTO sys_role_menu (role_id, menu_id) VALUES (1, 317);
-- INSERT INTO sys_role_menu (role_id, menu_id) VALUES (1, 318);
-- INSERT INTO sys_role_menu (role_id, menu_id) VALUES (1, 319);

-- ==============================
-- 验证是否添加成功
-- ==============================
-- SELECT * FROM sys_role_menu WHERE menu_id IN (317, 318, 319);
