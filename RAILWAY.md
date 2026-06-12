# Railway 部署配置

## 部署步骤

### 1. 连接 GitHub 仓库
- 访问 https://railway.app
- 使用 GitHub 账号登录
- 点击 "New Project"
- 选择 "Deploy from GitHub repo"
- 选择你的仓库

### 2. 添加 MySQL 数据库

在 Railway 项目中：
1. 点击 "New" → "Database" → "Add MySQL"
2. 等待 MySQL 实例创建完成
3. 点击 MySQL 服务，查看连接信息

### 3. 配置环境变量

在主服务（smart-parking）中，添加以下环境变量：

```bash
# 数据库配置（从 Railway MySQL 获取）
SPRING_DATASOURCE_URL=jdbc:mysql://${{MYSQLHOST}}:${{MYSQLPORT}}/${{MYSQLDATABASE}}?characterEncoding=utf-8&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai
SPRING_DATASOURCE_USERNAME=${{MYSQLUSER}}
SPRING_DATASOURCE_PASSWORD=${{MYSQLPASSWORD}}

# 服务器端口
SERVER_PORT=8081

# 文件路径（Railway 临时目录）
file.path=/tmp/images

# 项目访问地址
project.url=${{RAILWAY_PUBLIC_DOMAIN}}
```

### 4. 导入数据库数据

1. 使用 Railway 提供的 MySQL 连接信息
2. 使用 MySQL 客户端（如 Navicat、DBeaver 或命令行）连接数据库
3. 导入 `smartparking.sql` 文件

**使用命令行导入**：
```bash
mysql -h ${MYSQLHOST} -P ${MYSQLPORT} -u ${MYSQLUSER} -p${MYSQLPASSWORD} ${MYSQLDATABASE} < smartparking.sql
```

### 5. 等待部署完成

- Railway 会自动构建 Docker 镜像
- 构建完成后，服务会自动启动
- 点击 "Generate Domain" 获取公网访问地址

### 6. 访问系统

- 访问 Railway 生成的域名
- 使用默认账号登录：
  - 用户名：`admin`
  - 密码：`123456`

## 故障排查

### 构建失败

检查 Dockerfile 是否正确，确保：
- Maven 构建成功
- JAR 文件生成在正确位置

### 启动失败

查看 Railway 的日志输出：
```bash
# 在 Railway 控制面板查看 "Deployments" → "View Logs"
```

常见问题：
1. **数据库连接失败**：检查环境变量是否正确
2. **端口错误**：确保使用 8081 端口
3. **内存不足**：Railway 免费套餐有内存限制

### 数据库问题

确保已导入 `smartparking.sql` 文件，并且：
- 数据库表已创建
- 初始数据已插入
- 用户权限正确

## 环境变量说明

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `SPRING_DATASOURCE_URL` | 数据库连接 URL | 自动生成 |
| `SPRING_DATASOURCE_USERNAME` | 数据库用户名 | root |
| `SPRING_DATASOURCE_PASSWORD` | 数据库密码 | Railway 提供 |
| `SERVER_PORT` | 服务端口 | 8081 |
| `file.path` | 文件上传路径 | /tmp/images |
| `project.url` | 项目访问地址 | Railway 域名 |

## 注意事项

1. **免费套餐限制**：
   - 每月 500 小时运行时间
   - 512MB 内存
   - 1GB 磁盘空间

2. **数据持久化**：
   - Railway 的 MySQL 是持久化的
   - 文件上传目录是临时的

3. **域名**：
   - Railway 提供临时域名
   - 可以绑定自定义域名（需要付费）

4. **自动休眠**：
   - 免费账户长时间不活动会休眠
   - 访问时会自动唤醒（需要几分钟）