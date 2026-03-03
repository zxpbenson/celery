# Docker Compose 开发环境集合

这是一个专门用于开发环境的 Docker Compose 配置文件集合，旨在帮助开发者快速搭建本地开发所需的各种中间件和服务。

## 📁 项目结构

```
.
├── kafka/      # Kafka 消息队列
├── mysql/      # MySQL 数据库
├── nginx/      # Nginx 反向代理/Web服务器
├── nsq/        # NSQ 分布式消息队列
└── redis/      # Redis 缓存/消息队列
```

## 🚀 快速开始

### 前置要求

- [Docker](https://www.docker.com/get-started) (推荐 20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (推荐 2.0+)

### 使用方法

1. 进入对应服务的目录：
   ```bash
   cd <service-name>
   ```

2. 启动服务：
   ```bash
   docker-compose up -d
   ```

3. 停止服务：
   ```bash
   docker-compose down
   ```

4. 查看服务状态：
   ```bash
   docker-compose ps
   ```

5. 查看服务日志：
   ```bash
   docker-compose logs -f
   ```

## 📦 服务说明

### Kafka
分布式流处理平台，用于构建实时数据管道和流应用。

### MySQL
最流行的开源关系型数据库，适用于各种应用场景。

### Nginx
高性能的 HTTP 和反向代理服务器，也是一个 IMAP/POP3/SMTP 服务器。

### NSQ
实时分布式消息平台，设计用于大规模数据处理。

### Redis
开源的内存数据结构存储，可用作数据库、缓存和消息代理。

## ⚙️ 配置说明

每个服务目录下包含：
- `docker-compose.yml` - Docker Compose 配置文件
- `README.md` - 该服务的详细使用说明（如有）
- 相关配置文件目录（如 `conf/`、`data/` 等）

## 🔧 常用命令

| 命令 | 说明 |
|------|------|
| `docker-compose up -d` | 后台启动服务 |
| `docker-compose down` | 停止并移除容器 |
| `docker-compose stop` | 停止服务 |
| `docker-compose start` | 启动服务 |
| `docker-compose restart` | 重启服务 |
| `docker-compose ps` | 查看服务状态 |
| `docker-compose logs -f` | 查看实时日志 |
| `docker-compose exec <service> bash` | 进入容器 |

## 📝 注意事项

1. 这些配置仅用于**开发环境**，不建议直接用于生产环境
2. 默认配置使用简单的密码，生产环境请务必修改
3. 数据持久化目录默认挂载到各服务目录下的 `data/` 文件夹
4. 如遇端口冲突，请修改 `docker-compose.yml` 中的端口映射

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来完善这个项目！

## 📄 License

MIT License