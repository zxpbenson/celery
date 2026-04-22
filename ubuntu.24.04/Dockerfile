#FROM ubuntu:24.04
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# 重写 sources（HTTP bootstrap）
RUN rm -f /etc/apt/sources.list.d/ubuntu.sources && \
    printf "Types: deb\n\
URIs: http://archive.ubuntu.com/ubuntu\n\
Suites: noble noble-updates noble-backports\n\
Components: main restricted universe multiverse\n\
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n\n\
Types: deb\n\
URIs: http://security.ubuntu.com/ubuntu\n\
Suites: noble-security\n\
Components: main restricted universe multiverse\n\
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n" \
> /etc/apt/sources.list.d/ubuntu.sources

# bootstrap CA（无缓存）
RUN mkdir -p /tmp/apt-cache && \
    apt-get update -o Acquire::AllowInsecureRepositories=true && \
    apt-get install -y --allow-unauthenticated \
        -o Dir::Cache::archives="/tmp/apt-cache" \
        ca-certificates && \
    rm -rf /tmp/apt-cache /var/lib/apt/lists/*

# 切 HTTPS
RUN sed -i 's|http://|https://|g' /etc/apt/sources.list.d/ubuntu.sources

# 正常安装
RUN apt-get update && apt-get install -y \
    openssh-server sudo \
 && mkdir -p /var/run/sshd \
 && rm -rf /var/lib/apt/lists/*

RUN echo "root:root" | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
