# Nginx 开发环境

Nginx 是一个高性能的 HTTP 和反向代理服务器，也是一个 IMAP/POP3/SMTP 服务器。

## 服务组件

| 服务 | 端口 | 说明 |
|------|------|------|
| nginx-proxy-manager | 80, 443, 81 | Nginx Proxy Manager（含 Web 管理界面） |

## 目录结构

```
nginx/
├── docker-compose.yml
├── README.md
├── data/                    # Nginx Proxy Manager 数据存储
├── letsencrypt/             # Let's Encrypt 证书存储
├── conf/                    # 配置文件（仅用于兼容）
│   ├── nginx.conf
│   └── sites-available/
│       └── default.conf
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

### 访问管理界面

- **管理界面**: http://localhost:81
- **默认登录**: admin@example.com / changeme

```yaml
environment:
  - TZ=Asia/Shanghai  # 修改为所需的时区
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

- **Nginx Proxy Manager**: http://localhost
- **管理界面**: http://localhost:81

## 基本使用

### 通过 Web 管理界面添加站点

1. 访问管理界面: http://localhost:81
2. 使用默认凭证登录: admin@example.com / changeme
3. 在 "Hosts" > "Add Proxy Host" 中添加新的反向代理配置
4. 配置域名、后端地址、SSL 证书等参数
5. 保存后自动生效，无需手动重载

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

1. 在管理界面的 "SSL Certificates" 中上传证书
2. 或在 "Hosts" > "Add Proxy Host" 中启用 Let's Encrypt 自动申请
3. 选择域名并启用 HTTPS，系统将自动配置和续期

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

### 反向代理（通过管理界面）

1. 在管理界面 "Hosts" > "Add Proxy Host" 中配置
2. 设置域名、后端地址、端口
3. 启用 HTTPS（可选）
4. 保存后自动生效

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
2. 日志和数据会持久化到本地目录
3. 所有配置通过 Web 管理界面完成，无需手动编辑配置文件
4. 生产环境请配置 HTTPS 和适当的安全策略
5. 默认凭证 admin@example.com / changeme 请在首次登录后立即修改