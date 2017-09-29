---
title: "15.配置过程 Apache"
date: 2017-09-24T17:58:08+08:00
menu: main
draft: false
---


### 一、下载

https://www.apachelounge.com/download/VC14/

     1. 选择 win64-VC14.zip (与 VC14 的 php 统一)
     2. Apache 2.4 modules VC14 请酌情下载，因为 win64-VC14.zip 已经带了很多 module

但是 **mod_fcgid** 这个是必须下载的，因为就是用 fastcgi 跑 php


### 二、精简

     1. mysql 中仅保留 bin、lib 和 share 三个子目录，其他子目录及文件全部删除。
     2. bin 目录下仅保留 mysqld.exe、mysqladmin.exe和 mysql.exe 三个文件，其他子目录及文件全部删除。
     3. lib 目录下保留 libmysql.dll 和 libmysql.lib 两个文件，其他子目录及文件全部删除。
     4. share 目录下仅保留 charsets 和 english 两个子目录，其他子目录及文件全部删除。


### 三、安装

     1. 解压至 apache
     2. 修改 conf/httpd.conf 这个配置文件
     3. 启动 <参考：启动套件.bat>

httpd.conf 的 配置

```php
# ServerRoot    指向 apache 的目录
ServerRoot "c:/Apache24"

# Listen        是监听的端口，默认80，如果想做 https 站，可以追加 Listen 443
Listen 80
Listen 443

# ↓↓这些都是给默认站点设置的
# ServerName    服务器的域名，不配会报错，一般配成 localhost
ServerName localhost
# Directory     全局的一些设置
<Directory />
    AllowOverride none
    Require all denied
</Directory>
DocumentRoot "c:/Apache24/htdocs"
# Directory     加了目录就是对全局设置的一些重写
<Directory "c:/Apache24/htdocs">
    #
    # Possible values for the Options directive are "None", "All",
    # or any combination of:
    #   Indexes Includes FollowSymLinks SymLinksifOwnerMatch ExecCGI MultiViews
    #
    # Note that "MultiViews" must be named *explicitly* --- "Options All"
    # doesn't give it to you.
    #
    # The Options directive is both complicated and important.  Please see
    # http://httpd.apache.org/docs/2.4/mod/core.html#options
    # for more information.
    #
    Options Indexes FollowSymLinks

    #
    # AllowOverride controls what directives may be placed in .htaccess files.
    # It can be "All", "None", or any combination of the keywords:
    #   AllowOverride FileInfo AuthConfig Limit
    #
    AllowOverride None

    #
    # Controls who can get stuff from this server.
    #
    Require all granted
</Directory>

# ↓↓这些可以使用默认，不配置
# ErrorLog 错误日志，可以选择移到 tmp 里
ErrorLog "logs/error.log"

# LogLevel 日志级别
LogLevel warn

# CustomLog 访问日志，可以选择移到 tmp 里
CustomLog "logs/access.log" common

# ScriptAlias 不用可以注视掉
#ScriptAlias /cgi-bin/ "c:/Apache24/cgi-bin/"
#<Directory "c:/Apache24/cgi-bin">
#    AllowOverride None
#    Options None
#    Require all granted
#</Directory>
```

```php
# DirectoryIndex 在入口文件里添加 index.php，放在前面
DirectoryIndex index.php index.html

# 添加
LoadModule fcgid_module modules/mod_fcgid.so
<IfModule fcgid_module>
    Include conf/extra/httpd-fcgid.conf
    AddHandler fcgid-script .php
    FcgidWrapper "D:/phpCaddy/php7.1nts/php-cgi.exe" .php
</IfModule>

# Include 打开 httpd-mpm.conf 添加 Include conf/vhost/*.conf
Include conf/extra/httpd-mpm.conf
# 加了这句，就要建个默认的空 .conf 否则无法启动
Include conf/vhost/*.conf
```


### 四、备忘

httpd.exe –k install -n "Apache24"

    httpd.exe –k install 可以把 apache 添加为系统服务

    -n "Apache24" 可以控制要添加的系统服务 “名字”

httpd.exe -k uninstall -n "Apache24"

    httpd.exe -k uninstall 可以把 apache 系统服务移除

    -n "Apache24" 可以控制要移除的系统服务 “名字”

80端口被占用

    `no listening sockets available, shutting down` 错误信息是：监听端口被占用了，常见于默认80端口
