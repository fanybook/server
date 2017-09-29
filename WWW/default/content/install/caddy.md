---
title: "11.配置过程 Caddy"
date: 2017-09-24T17:58:08+08:00
menu: main
draft: false
---


### 一、下载

https://caddyserver.com/download

    选择 Windows 64-bit
    插件 http.cors http.filemanager http.git http.hugo
    授权 Personal (free)

### 二、安装

     1. 解压至 caddy
     2. 在 caddy 目录   新建 Caddyfile 文件，写入 `import ./vhosts/*`
     3. 在 caddy 目录   新建 vhosts 目录
     4. 在 vhosts 目录  新建 default.conf 文件，写default站点的配置

default.conf 的配置
```php
127.0.0.1:80 {
    #为了做成套件无奈写成相对路径，其实写绝对路径更直观
    root                ./WWW/default/public

    fastcgi / 127.0.0.1:9000 php {
        index index.php
    }
}
```
