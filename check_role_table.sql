-- 检查 sys_role 表结构
DESCRIBE sys_role;

-- 查看所有角色数据
SELECT * FROM sys_role;

-- 查看用户角色关系
SELECT * FROM sys_user_role;

-- 查看角色菜单关系
SELECT * FROM sys_role_menu LIMIT 10;
