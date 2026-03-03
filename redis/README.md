# Redis 开发环境

Redis 是一个开源的内存数据结构存储，可用作数据库、缓存和消息代理。

## 服务组件

| 服务 | 端口 | 说明 |
|------|------|------|
| redis | 6379 | Redis 主服务 |
| redis-commander | 8081 | Web 管理界面 |

## 目录结构

```
redis/
├── docker-compose.yml
├── README.md
├── conf/
│   └── redis.conf           # Redis 配置文件
├── data/                    # 数据持久化目录 (dump.rdb, appendonly.aof)
└── logs/                    # 日志目录
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

- **Redis**: localhost:6379
- **Redis Commander**: http://localhost:8081

## 基本使用

### 命令行连接

```bash
docker exec -it redis_redis_1 redis-cli
```

### 查看所有键

```bash
keys *
```

### 设置和获取值

```bash
set test_key "hello world"
get test_key
```

### 查看内存使用

```bash
info memory
```

### 查看持久化状态

```bash
info persistence
```

### 清空数据库

```bash
flushall
```

## 配置说明

- **持久化**: 同时启用 RDB 和 AOF
- **内存限制**: 256MB，使用 LRU 策略
- **日志**: 记录到 `logs/redis.log`
- **数据**: 存储在 `data/` 目录下的 `dump.rdb` 和 `appendonly.aof`

## 自定义配置

修改 `conf/redis.conf` 文件后，重启服务生效：

```bash
docker-compose down
docker-compose up -d
```

## 注意事项

1. 默认配置仅用于开发环境
2. 数据和日志会持久化到本地目录
3. 如需修改配置，可编辑 `conf/redis.conf` 文件
4. 生产环境建议设置密码（取消 `requirepass` 注释）