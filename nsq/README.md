# NSQ 开发环境

NSQ 是一个实时分布式消息平台，设计用于大规模数据处理。

## 服务组件

| 服务 | 端口 | 说明 |
|------|------|------|
| nsqlookupd | 4160 (TCP), 4161 (HTTP) | 服务发现和注册中心 |
| nsqd | 4150 (TCP), 4151 (HTTP) | 消息队列守护进程 |
| nsqadmin | 4171 (HTTP) | Web 管理界面 |

## 目录结构

```
nsq/
├── docker-compose.yml
├── README.md
├── data/                    # 数据持久化目录
│   ├── nsqlookupd/
│   └── nsqd/
└── logs/                    # 日志目录
    ├── nsqlookupd/
    ├── nsqd/
    └── nsqadmin/
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

- **nsqadmin Web UI**: http://localhost:4171
- **nsqd HTTP API**: http://localhost:4151
- **nsqlookupd HTTP API**: http://localhost:4161

## 基本使用

### 创建 Topic

```bash
curl -X POST http://localhost:4151/topic/create?topic=test_topic
```

### 创建 Channel

```bash
curl -X POST http://localhost:4151/channel/create?topic=test_topic&channel=test_channel
```

### 发布消息

```bash
curl -d "hello world" http://localhost:4151/pub?topic=test_topic
```

### 消费消息

```bash
curl "http://localhost:4151/sub?topic=test_topic&channel=test_channel"
```

## 常用命令

```bash
# 查看统计信息
curl http://localhost:4151/stats

# 查看节点信息
curl http://localhost:4161/nodes

# 查看话题列表
curl http://localhost:4161/topics

# 查看频道列表
curl http://localhost:4161/channels?topic=test_topic
```

## 注意事项

1. 默认配置仅用于开发环境
2. 数据和日志会持久化到本地目录
3. 如需修改配置，可编辑 `docker-compose.yml` 文件

## 广播地址配置

在 Docker 环境中，NSQ 服务需要配置广播地址以便外部客户端正确连接：

- **nsqlookupd**: 使用 `--broadcast-address` 参数配置广播地址
- **nsqd**: 使用 `--broadcast-address` 参数配置广播地址

当前配置使用 `127.0.0.1` 作为广播地址，适用于本地开发。如需从其他机器访问，请修改为实际的宿主主机 IP 地址：

```yaml
# nsqlookupd
command: /nsqlookupd --broadcast-address=192.168.1.100

# nsqd
command: /nsqd --lookupd-tcp-address=nsqlookupd:4160 --broadcast-address=192.168.1.100
```

修改后重启服务：
```bash
docker-compose down
docker-compose up -d
```