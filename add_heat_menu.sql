-- 添加车位热度分析菜单
-- 执行方式：在 Navicat 中打开此文件并运行，或复制 SQL 到查询窗口执行

-- 1. 先检查父菜单是否存在（停车场管理，ID=295）
SELECT menu_id, name FROM sys_menu WHERE menu_id = 295;

-- 2. 添加车位热度分析菜单
INSERT INTO `sys_menu` VALUES (
    317,              -- menu_id: 菜单 ID（如果已存在可改为 318, 319 等）
    295,              -- parent_id: 父菜单 ID（停车场管理）
    '车位热度分析',    -- name: 菜单名称
    'car/parkHeat/statistics.html',  -- url: 页面路径
    NULL,             -- perms: 权限标识（留空）
    1,                -- type: 菜单类型（1=菜单）
    'layui-icon layui-icon-chart',   -- icon: 菜单图标
    2,                -- order_num: 排序号（数字越小越靠前）
    NOW(),            -- gmt_create: 创建时间
    NOW()             -- gmt_modified: 修改时间
);

-- 3. 验证是否添加成功
SELECT menu_id, parent_id, name, url, icon, order_num 
FROM sys_menu 
WHERE parent_id = 295 
ORDER BY order_num;

-- 4. 如果 menu_id 317 已存在，使用以下 SQL（取消注释）：
-- INSERT INTO `sys_menu` VALUES (
--     318,              -- menu_id: 改为 318
--     295,              -- parent_id
--     '车位热度分析',    -- name
--     'car/parkHeat/statistics.html',  -- url
--     NULL,             -- perms
--     1,                -- type
--     'layui-icon layui-icon-chart',   -- icon
--     2,                -- order_num
--     NOW(),            -- gmt_create
--     NOW()             -- gmt_modified
-- );
