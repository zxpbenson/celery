# Kafka 开发环境

Apache Kafka 是一个分布式流处理平台，用于构建实时数据管道和流应用。

## 服务组件

| 服务 | 端口 | 说明 |
|------|------|------|
| zookeeper | 2181 | Kafka 依赖的协调服务 |
| kafka | 9092 (内部), 9093 (外部) | 消息队列服务 |
| kafka-ui | 8080 | Web 管理界面 |

## 目录结构

```
kafka/
├── docker-compose.yml
├── README.md
├── conf/                    # 配置文件目录
│   ├── server.properties    # Kafka 配置文件
│   └── zoo.cfg              # ZooKeeper 配置文件
├── init/                    # 初始化脚本目录
│   └── 01-create-topics.sh  # 自动创建 topic 脚本
├── data/                    # 数据持久化目录
│   ├── zookeeper/
│   └── kafka/
└── logs/                    # 日志目录
    ├── zookeeper/
    └── kafka/
```

## 配置说明

### ZooKeeper 配置

ZooKeeper 配置文件位于 [`conf/zoo.cfg`](conf/zoo.cfg)，主要配置项：

- **tickTime**: 心跳时间（2000ms）
- **initLimit**: 初始化连接限制（10个tickTime）
- **syncLimit**: 同步限制（5个tickTime）
- **dataDir**: 数据目录
- **clientPort**: 客户端端口（2181）
- **autopurge**: 自动清理快照

### Kafka 配置

Kafka 配置通过环境变量在 docker-compose.yml 中设置：

- **分区数**: 3
- **副本因子**: 1
- **日志保留**: 168小时（7天）
- **自动创建 Topic**: 启用
- **删除 Topic**: 启用

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

- **Kafka UI**: http://localhost:8080
- **Kafka Broker**: localhost:9093 (外部访问)
- **Zookeeper**: localhost:2181

## 基本使用

### 创建 Topic

```bash
docker exec -it kafka_kafka_1 kafka-topics.sh --create --topic test_topic --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
```

### 列出所有 Topic

```bash
docker exec -it kafka_kafka_1 kafka-topics.sh --list --bootstrap-server localhost:9092
```

### 发送消息

```bash
docker exec -it kafka_kafka_1 kafka-console-producer.sh --topic test_topic --bootstrap-server localhost:9092
```

### 消费消息

```bash
docker exec -it kafka_kafka_1 kafka-console-consumer.sh --topic test_topic --from-beginning --bootstrap-server localhost:9092
```

### 查看 Topic 详情

```bash
docker exec -it kafka_kafka_1 kafka-topics.sh --describe --topic test_topic --bootstrap-server localhost:9092
```

## 注意事项

1. 默认配置仅用于开发环境
2. 数据和日志会持久化到本地目录
3. 如需修改配置，可编辑 `docker-compose.yml` 文件
4. 外部访问使用 9093 端口，内部通信使用 9092 端口