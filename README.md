# 🅿️ 智能停车场管理系统

基于 Spring Boot + Vue.js 的智能停车场管理系统，支持车辆管理、停车场管理、停车记录、订单管理等功能。

## 📋 技术栈

- **后端**: Spring Boot 2.2.6 + Spring Data JPA
- **前端**: Vue.js 2.x + iView
- **数据库**: MySQL 8.0+
- **安全框架**: Apache Shiro

## 🚀 快速开始

### 环境要求

- JDK 1.8+
- Maven 3.6+
- MySQL 8.0+

### Railway 部署（推荐）

1. **连接 Railway 账户**
   - 访问 https://railway.app
   - 使用 GitHub 账号登录

2. **创建新项目**
   - 点击 "New Project"
   - 选择 "Deploy from GitHub repo"
   - 选择你的仓库

3. **配置环境变量**
   
   在 Railway 控制面板中添加以下环境变量：
   
   | 变量名 | 值 | 说明 |
   |--------|-----|------|
   | `SPRING_DATASOURCE_URL` | `jdbc:mysql://mysql.railway.internal:3306/railway?characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai` | Railway MySQL 连接 |
   | `SPRING_DATASOURCE_USERNAME` | `root` | 数据库用户名 |
   | `SPRING_DATASOURCE_PASSWORD` | `你的密码` | 数据库密码 |
   | `SERVER_PORT` | `8081` | 服务端口 |

4. **部署**
   - Railway 会自动构建并部署
   - 等待构建完成后，会生成一个公网访问地址
   - 点击 "Generate Domain" 获取访问链接

5. **数据库配置**
   - 在 Railway 中添加 MySQL 插件
   - 导入 `smartparking.sql` 文件
   - 复制 Railway 提供的数据库连接信息

### 本地运行

**开发环境运行**：

```bash
cd smart-parking-master
mvn spring-boot:run
```

**打包部署**：

```bash
mvn clean package -DskipTests
java -jar target/Smart-Parking.jar
```

### 访问地址

- **首页**: http://localhost:8081
- **默认账号**: admin / 123456

## 📁 项目结构

```
smart-parking-master/
├── src/main/java/com/smart/
│   ├── common/          # 公共模块（工具类、配置）
│   ├── module/car/      # 车辆管理模块
│   ├── module/finance/  # 财务管理模块
│   ├── module/pay/      # 支付管理模块
│   ├── module/sys/      # 系统管理模块
│   └── Application.java # 启动类
├── src/main/resources/
│   ├── static/          # 静态资源（CSS、JS、图片）
│   ├── templates/       # Thymeleaf 模板
│   └── application*.properties # 配置文件
├── smartparking.sql     # 数据库初始化脚本
└── pom.xml              # Maven 配置
```

## 🔧 功能模块

| 模块 | 功能 |
|------|------|
| 车辆管理 | 车辆信息管理、车牌识别 |
| 停车场管理 | 停车场信息、车位管理 |
| 停车记录 | 入场记录、离场记录 |
| 订单管理 | 订单列表、费用结算 |
| 系统管理 | 用户、角色、菜单管理 |

## 🌐 让外网访问

### 方案一：Railway 部署（推荐 ⭐）

**优点**：免费、简单、自动部署、提供公网域名

1. **访问 Railway**
   - 官网：https://railway.app
   - 使用 GitHub 账号登录

2. **创建项目**
   - 点击 "New Project"
   - 选择 "Deploy from GitHub repo"
   - 选择你的仓库

3. **添加 MySQL 数据库**
   - 在项目中点击 "New" → "Database" → "Add MySQL"
   - 等待 MySQL 实例创建完成

4. **配置环境变量**
   
   在 Railway 项目设置中，添加以下环境变量：
   
   ```bash
   SPRING_DATASOURCE_URL=jdbc:mysql://${{MYSQLHOST}}:${{MYSQLPORT}}/${{MYSQLDATABASE}}?characterEncoding=utf-8&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai
   SPRING_DATASOURCE_USERNAME=${{MYSQLUSER}}
   SPRING_DATASOURCE_PASSWORD=${{MYSQLPASSWORD}}
   SERVER_PORT=8081
   file.path=/tmp/images
   project.url=${{RAILWAY_PUBLIC_DOMAIN}}
   ```

5. **导入数据库数据**
   
   使用 Railway 提供的 MySQL 连接信息，导入 `smartparking.sql` 文件：
   
   ```bash
   mysql -h ${{MYSQLHOST}} -P ${{MYSQLPORT}} -u ${{MYSQLUSER}} -p${{MYSQLPASSWORD}} ${{MYSQLDATABASE}} < smartparking.sql
   ```

6. **获取访问链接**
   - Railway 会自动构建并部署
   - 点击 "Generate Domain" 获取公网访问地址
   - 格式类似：`https://your-project.up.railway.app`

**详细教程**：查看 [RAILWAY.md](RAILWAY.md) 文件

### 方案二：内网穿透（本地测试）

使用 **Ngrok** 让本地服务可以被外网访问：

1. 下载 Ngrok：https://ngrok.com/download
2. 运行命令：

```bash
ngrok http 8081
```

3. 获取临时域名（如：`http://abc123.ngrok.io`）

**优点**：快速测试，无需服务器  
**缺点**：每次重启域名会变

### 方案三：部署到云服务器（长期稳定）

**推荐平台**：阿里云 / 腾讯云 / 华为云（学生有优惠）

**步骤**：
1. 购买云服务器（选择 Ubuntu 或 CentOS 系统）
2. 安装 Java 环境
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install openjdk-8-jdk

# CentOS
sudo yum install java-1.8.0-openjdk
```
3. 安装 MySQL
```bash
# Ubuntu/Debian
sudo apt install mysql-server
```
4. 创建数据库并导入数据
```bash
mysql -u root -p
CREATE DATABASE smartparking;
USE smartparking;
SOURCE smartparking.sql;
```
5. 上传并运行项目
```bash
nohup java -jar Smart-Parking.jar > app.log 2>&1 &
```
6. 开放端口（在云服务器控制台配置安全组，开放 8081 端口）
7. 访问地址：`http://你的服务器IP:8081`

**优点**：稳定、持久、可自定义  
**缺点**：需要付费（学生优惠约 10 元/月）
2. 安装 JDK 和 MySQL
3. 上传并运行项目：

```bash
# 后台运行
nohup java -jar Smart-Parking.jar > app.log 2>&1 &
```

## 📝 API 接口

| 接口 | 方法 | 描述 |
|------|------|------|
| `/car/carManage/list` | GET | 获取车辆列表 |
| `/car/parkManage/list` | GET | 获取停车场列表 |
| `/car/parkingRecord/list` | GET | 获取停车记录 |
| `/finance/order/list` | GET | 获取订单列表 |

## 📄 License

MIT License

---

**项目作者**: 你的名字  
**联系方式**: 你的邮箱  
**GitHub**: [你的仓库地址](https://github.com/你的用户名/仓库名)