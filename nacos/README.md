# Nacos 单机开发环境 (Derby)

Nacos 是阿里巴巴开源的一个动态服务发现、配置管理和服务管理平台，致力于帮助你发现、配置和管理微服务。

本目录提供 **单机模式** 的 Nacos，使用 Nacos 内置的 **Derby** 嵌入式数据库存储配置数据，无需依赖外部数据库，开箱即用。

## 服务组件

| 服务 | 端口 | 说明 |
|------|------|------|
| nacos | 8848 | 控制台 & Open API (HTTP) |
| nacos | 9848 | 客户端 gRPC 端口 (主端口 + 1000) |
| nacos | 9849 | 服务端 gRPC 端口 (主端口 + 1001) |

## 目录结构

```
nacos/
├── docker-compose.yml
├── README.md
├── data/                    # 数据持久化目录 (含 Derby 数据库文件)
└── logs/                    # 日志目录
```

## 配置说明

- **模式**: standalone (单机模式)
- **存储**: 内嵌 Derby (单机模式默认即为 Derby，无需额外配置)
- **鉴权**: 开启 (NACOS_AUTH_ENABLE=true)
- **JVM**: -Xms512m -Xmx512m -Xmn256m
- **时区**: Asia/Shanghai

> 鉴权 Token (`NACOS_AUTH_TOKEN`) 必须是 Base64 编码且解码后至少 32 个字符。docker-compose.yml 中的示例 Token 解码后为 `ThisIsMyCustomSecretKey0123456789ABCDEFG`，仅供开发使用，生产环境请务必替换。

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

### 查看日志

```bash
docker-compose logs -f nacos
```

## 访问地址

- **Nacos 控制台**: http://localhost:8848/nacos
- **Open API**: http://localhost:8848/nacos/v1/
- **客户端 gRPC**: localhost:9848

## 默认账号

| 账号 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | nacos | nacos |

首次启动后建议在控制台修改默认密码。

## 基本使用

### 发布配置 (curl)

```bash
curl -X POST 'http://localhost:8848/nacos/v1/cs/configs' \
  -d 'dataId=test.yaml&group=DEFAULT_GROUP&content=server.port=8080&type=yaml'
```

### 获取配置 (curl)

```bash
curl 'http://localhost:8848/nacos/v1/cs/configs?dataId=test.yaml&group=DEFAULT_GROUP'
```

### 注册服务实例 (curl)

```bash
curl -X POST 'http://localhost:8848/nacos/v1/ns/instance' \
  -d 'serviceName=demo-service&ip=127.0.0.1&port=8080'
```

### 查询服务实例 (curl)

```bash
curl 'http://localhost:8848/nacos/v1/ns/instance/list?serviceName=demo-service'
```

### Spring Cloud / Java SDK 接入

```yaml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: 127.0.0.1:8848
        username: nacos
        password: nacos
      config:
        server-addr: 127.0.0.1:8848
        username: nacos
        password: nacos
        file-extension: yaml
```

## 注意事项

1. 单机 + Derby 模式 **不支持** 数据多节点同步，仅适用于开发/测试环境
2. 数据持久化在 `./data` 目录下的 Derby 数据库文件中，重启不丢数据
3. 如需多节点高可用，请使用 `../nacos-cluster/` (Derby + Raft 内嵌存储集群)，或切换 MySQL 外置存储
4. Nacos 2.x 客户端必须同时联通 8848 (HTTP) 与 9848 (gRPC) 端口
5. 鉴权 Token 与默认密码均为开发环境配置，生产环境请务必修改
