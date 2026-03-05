# Kafka 开发环境

Apache Kafka 是一个分布式流处理平台，用于构建实时数据管道和流应用。

## 服务组件

| 服务 | 端口 | 说明 |
|------|------|------|
| kafka | 9092 (内部), 9093 (外部) | 消息队列服务 |
| kafka-ui | 8080 | Web 管理界面 |

## 目录结构

```
kafka/
├── docker-compose.yml
├── README.md
├── data/                    # 数据持久化目录
│   ├── zookeeper/
│   └── kafka/
└── logs/                    # 日志目录
    ├── zookeeper/
    └── kafka/
```

## 配置说明

### Kafka 配置

注意：启动前，请将 KAFKA_CFG_ADVERTISED_LISTENERS 中的 your-host-ip 替换为你本地IP

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