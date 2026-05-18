# Nacos 集群开发环境 (Derby + Raft)

Nacos 集群模式默认使用外置 MySQL 存储配置数据。从 Nacos 2.x 起官方支持 **内嵌存储模式 (Embedded Storage)**：每个节点本地保留一个 Derby 数据库，节点间通过 **JRaft** 协议同步配置数据，实现集群高可用而无需依赖外部数据库。

本目录提供 3 节点 Nacos 集群，使用 `MODE=cluster` + `EMBEDDED_STORAGE=embedded` 启用 **Derby + Raft** 模式。

## 服务组件

| 服务 | 主端口 (主机) | gRPC 客户端 | gRPC 服务端 | Raft | 说明 |
|------|--------------|------------|------------|------|------|
| nacos1 | 8848 | 9848 | 9849 | 7848 | 集群节点 1 |
| nacos2 | 8858 | 9858 | 9859 | 7858 | 集群节点 2 |
| nacos3 | 8868 | 9868 | 9869 | 7868 | 集群节点 3 |

> 端口设计遵循 Nacos 2.x 规则：客户端 gRPC = 主端口 + 1000，服务端 gRPC = 主端口 + 1001，Raft = 主端口 - 1000。每个节点采用不同的主端口，保证从主机直接访问任意一个节点时偏移关系仍然成立，SDK 可以直连。

## 目录结构

```
nacos-cluster/
├── docker-compose.yml
├── README.md
├── data/                    # 数据持久化目录
│   ├── nacos1/              # 节点 1 的 Derby 数据
│   ├── nacos2/
│   └── nacos3/
└── logs/                    # 日志目录
    ├── nacos1/
    ├── nacos2/
    └── nacos3/
```

## 配置说明

- **模式**: cluster (集群模式)
- **存储**: `EMBEDDED_STORAGE=embedded` 内嵌 Derby + JRaft 同步
- **集群成员**: `NACOS_SERVERS=nacos1:8848 nacos2:8858 nacos3:8868`
- **鉴权**: 开启 (NACOS_AUTH_ENABLE=true)
- **JVM**: -Xms512m -Xmx512m -Xmn256m (每节点)
- **时区**: Asia/Shanghai

> 鉴权 Token (`NACOS_AUTH_TOKEN`) 必须是 Base64 编码且解码后至少 32 个字符，3 个节点必须保持一致。docker-compose.yml 中的示例 Token 解码后为 `ThisIsMyCustomSecretKey0123456789ABCDEFG`，仅供开发使用，生产环境请务必替换。

## 快速开始

### 启动集群

```bash
docker-compose up -d
```

启动后约需 30~60 秒完成 Raft 选举与数据同步。

### 停止集群

```bash
docker-compose down
```

### 查看集群状态

```bash
docker-compose ps
```

### 查看日志

```bash
# 查看所有节点
docker-compose logs -f

# 单独查看某个节点
docker-compose logs -f nacos1
```

## 访问地址

| 节点 | 控制台 | Open API | 客户端 gRPC |
|------|--------|----------|-------------|
| nacos1 | http://localhost:8848/nacos | http://localhost:8848/nacos/v1/ | localhost:9848 |
| nacos2 | http://localhost:8858/nacos | http://localhost:8858/nacos/v1/ | localhost:9858 |
| nacos3 | http://localhost:8868/nacos | http://localhost:8868/nacos/v1/ | localhost:9868 |

任意节点均可作为控制台入口，数据通过 Raft 自动同步。

## 默认账号

| 账号 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | nacos | nacos |

首次启动后建议在控制台修改默认密码。

## 基本使用

### 查看集群节点列表

```bash
curl 'http://localhost:8848/nacos/v1/core/cluster/nodes'
```

或在控制台 -> 集群管理 -> 节点列表 中查看，预期可见 3 个节点。

### 验证 Raft 数据同步

```bash
# 1. 在 nacos1 上发布配置
curl -X POST 'http://localhost:8848/nacos/v1/cs/configs' \
  -d 'dataId=test.yaml&group=DEFAULT_GROUP&content=hello=world&type=yaml'

# 2. 从 nacos2 读取
curl 'http://localhost:8858/nacos/v1/cs/configs?dataId=test.yaml&group=DEFAULT_GROUP'

# 3. 从 nacos3 读取
curl 'http://localhost:8868/nacos/v1/cs/configs?dataId=test.yaml&group=DEFAULT_GROUP'
```

3 个节点应返回完全相同的内容，说明 Raft 同步正常。

### 故障切换演示

```bash
# 停掉一个节点 (例如 nacos1)
docker-compose stop nacos1

# 在 nacos2 上写入数据
curl -X POST 'http://localhost:8858/nacos/v1/cs/configs' \
  -d 'dataId=failover.yaml&group=DEFAULT_GROUP&content=after-failover=true&type=yaml'

# 恢复 nacos1，验证它会自动同步缺失的数据
docker-compose start nacos1
sleep 30
curl 'http://localhost:8848/nacos/v1/cs/configs?dataId=failover.yaml&group=DEFAULT_GROUP'
```

### Spring Cloud / Java SDK 接入

```yaml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: 127.0.0.1:8848,127.0.0.1:8858,127.0.0.1:8868
        username: nacos
        password: nacos
      config:
        server-addr: 127.0.0.1:8848,127.0.0.1:8858,127.0.0.1:8868
        username: nacos
        password: nacos
        file-extension: yaml
```

## 注意事项

1. Derby + Raft 模式适合开发/测试环境，对运维要求低；生产环境官方仍推荐使用外置 MySQL
2. 集群成员数量建议为 **奇数 (3, 5, 7)**，以避免 Raft 选举出现脑裂
3. `NACOS_SERVERS` 中的地址与端口必须与各节点 `NACOS_APPLICATION_PORT` 完全一致，且 3 个节点的列表内容必须相同
4. 鉴权 Token (`NACOS_AUTH_TOKEN`) 在 3 个节点上必须保持一致
5. 数据持久化在 `./data/nacos{1,2,3}` 下，**不要手动删除或互相拷贝**，会破坏 Raft 状态
6. 首次启动需要 30~60 秒完成 Raft 选举，期间控制台可能报 "no leader"，属于正常现象
7. Nacos 2.x 客户端必须同时联通 HTTP 主端口与 gRPC 端口 (主端口 + 1000)
8. 如需切换为 MySQL 外置存储，移除 `EMBEDDED_STORAGE=embedded` 并添加 `MYSQL_SERVICE_*` 相关环境变量即可
