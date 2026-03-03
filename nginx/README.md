# Nginx 开发环境

Nginx 是一个高性能的 HTTP 和反向代理服务器，也是一个 IMAP/POP3/SMTP 服务器。

## 服务组件

| 服务 | 端口 | 说明 |
|------|------|------|
| nginx | 80, 443 | Nginx 主服务 |
| nginx-proxy | 81 | Docker 自动反向代理 |

## 目录结构

```
nginx/
├── docker-compose.yml
├── README.md
├── conf/
│   ├── nginx.conf           # Nginx 主配置文件
│   └── sites-available/     # 站点配置目录
│       └── default.conf     # 默认站点配置
├── html/                    # 静态文件目录
├── logs/                    # 日志目录
│   ├── access.log
│   └── error.log
└── certs/                   # SSL 证书目录
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

### 重载配置

```bash
docker exec nginx_nginx_1 nginx -s reload
```

### 测试配置

```bash
docker exec nginx_nginx_1 nginx -t
```

## 访问地址

- **Nginx 主服务**: http://localhost
- **Nginx Proxy**: http://localhost:81

## 基本使用

### 添加新站点

1. 在 `conf/sites-available/` 目录下创建新的配置文件：

```nginx
server {
    listen       80;
    server_name  mysite.local;

    location / {
        proxy_pass http://backend:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

2. 重载 Nginx 配置：

```bash
docker exec nginx_nginx_1 nginx -s reload
```

### 配置 HTTPS

1. 将 SSL 证书放入 `certs/` 目录
2. 修改站点配置：

```nginx
server {
    listen       443 ssl;
    server_name  mysite.local;

    ssl_certificate     /etc/nginx/certs/server.crt;
    ssl_certificate_key /etc/nginx/certs/server.key;

    location / {
        root   /usr/share/nginx/html;
        index  index.html;
    }
}
```

### 部署静态文件

将静态文件放入 `html/` 目录，即可通过 http://localhost 访问。

## 常用配置示例

### 反向代理

```nginx
location /api/ {
    proxy_pass http://backend-service:8080/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```

### 负载均衡

```nginx
upstream backend {
    server backend1:8080;
    server backend2:8080;
}

server {
    location / {
        proxy_pass http://backend;
    }
}
```

## 注意事项

1. 默认配置仅用于开发环境
2. 日志会持久化到本地目录
3. 如需修改配置，编辑后执行重载命令
4. 生产环境请配置 HTTPS 和适当的安全策略