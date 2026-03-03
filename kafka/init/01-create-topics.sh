#!/bin/bash

# Kafka 初始化脚本
# 此脚本在容器启动时自动执行，用于创建必要的 topic

echo "正在创建 Kafka topics..."

# 等待 Kafka 启动
sleep 10

# 创建示例 topic
kafka-topics.sh --create --topic user-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1 --config retention.ms=604800000
kafka-topics.sh --create --topic order-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1 --config retention.ms=604800000
kafka-topics.sh --create --topic payment-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1 --config retention.ms=604800000

# 创建监控 topic
kafka-topics.sh --create --topic metrics --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1 --config retention.ms=604800000

# 列出所有 topic
echo "已创建的 topics:"
kafka-topics.sh --list --bootstrap-server localhost:9092

echo "Kafka 初始化完成！"