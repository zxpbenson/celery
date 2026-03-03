# MySQL 开发环境

MySQL 是最流行的开源关系型数据库管理系统，适用于各种应用场景。

## 服务组件

| 服务 | 端口 | 说明 |
|------|------|------|
| mysql | 3306 | MySQL 数据库服务 |
| phpmyadmin | 8080 | Web 管理界面 |

## 目录结构

```
mysql/
├── docker-compose.yml
├── README.md
├── data/                    # 数据持久化目录
├── logs/                    # 日志目录
├── conf/                    # 自定义配置文件目录
└── init/                    # 初始化 SQL 脚本目录
```

## 快速开始

### 启动服务

```bash
docker-compose up -d
```

### 停止服务

```bash
docker-compose down
```

### 查看服务状态

```bash
docker-compose ps
```

## 访问地址

- **MySQL**: localhost:3306
- **phpMyAdmin**: http://localhost:8080

## 默认账号

| 账号类型 | 用户名 | 密码 |
|----------|--------|------|
| Root | root | root123456 |
| 开发账号 | dev | dev123456 |

默认创建数据库: `dev`

## 基本使用

### 命令行连接

```bash
docker exec -it mysql_mysql_1 mysql -uroot -proot123456
```

### 备份数据库

```bash
docker exec mysql_mysql_1 mysqldump -uroot -proot123456 --all-databases > backup.sql
```

### 恢复数据库

```bash
docker exec -i mysql_mysql_1 mysql -uroot -proot123456 < backup.sql
```

### 导入 SQL 文件

将 SQL 文件放入 `init/` 目录，容器启动时会自动执行。

## 自定义配置

可在 `conf/` 目录下创建 `.cnf` 配置文件，容器会自动加载。

示例 `conf/custom.cnf`:

```ini
[mysqld]
max_connections=500
innodb_buffer_pool_size=256M
```

## 注意事项

1. 默认配置仅用于开发环境
2. 默认密码较简单，生产环境请务必修改
3. 数据和日志会持久化到本地目录
4. 如需修改配置，可编辑 `docker-compose.yml` 文件