# Ubuntu 24.04 开发环境

基于 Ubuntu 24.04 镜像，内置了 SSH 服务的开发环境容器，方便直接通过 SSH 进行访问和开发。

## 服务组件

| 服务 | 端口 | 说明 |
|------|------|------|
| ubuntu-ssh | 2022 | Ubuntu 容器 SSH 服务 |

## 目录结构

```
ubuntu.24.04/
├── docker-compose.yaml
├── Dockerfile
└── README.md
```

## 快速开始

### 构建并启动服务

由于包含自定义的 `Dockerfile`，首次启动或修改了 `Dockerfile` 后，建议使用 `--build` 参数重新构建镜像并启动服务：

```bash
docker-compose up -d --build
```

如果镜像已存在且无需更新，也可以直接启动：

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

- **SSH**: localhost:2022

## 默认账号

| 账号类型 | 用户名 | 密码 |
|----------|--------|------|
| Root | root | root |

## 基本使用

### 命令行连接 (SSH)

```bash
ssh root@localhost -p 2022
```

### 容器内直接执行

```bash
docker exec -it ubuntu-24-ssh /bin/bash
```

## 注意事项

1. 默认配置仅用于开发环境
2. 默认密码较简单，如对外开放请务必修改密码
3. 如需添加其他软件或修改配置，可编辑 `Dockerfile` 和 `docker-compose.yaml` 文件，并使用 `docker-compose up -d --build` 重新构建生效
