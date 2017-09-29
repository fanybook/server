---
title: "00.关于 phpCaddy"
date: 2017-09-24T17:58:08+08:00
menu: main
draft: false
---

### phpCaddy 是一个 windows 的 php + caddy服务器的套件

    只在64位win10上测试过，它包括：
     1. caddy   (golang 写的可以 自动https 的 HTTP/2 Web服务器)
     2. php     (以 fastcgi 方式运行，默认绑定 9000 端口)
     3. mysql   (5.7 支持 json 类型)
     4. redis   (现在也是标配了)
     5. apache  (给不习惯用 caddy 的人)

[^_^]:
    ### 组件的配置文件全部使用相对路径
    这样做的好处是：套件可以任意移动位置只用，而不是一移动位置就应为配置文件里的绝对路径而无法使用
    但是最终有了一个例外：那就是在配置 apache 的 fcgid 时，FcgidWrapper 如果使用 **相对路径** mod_fcgid.so 就找不到 php-cgi.exe，而如果相对于 mod_fcgid.so 时，apache 就启动不了，所以移动 phpCaddy 又想使用 apache 运行 php 的话，记得改 FcgidWrapper :D
    又一个例外诞生，配置 phpMysql 时发现如果 php.ini 的 session.save_path 使用相对路径，无论怎么配都是错的，尝试多次还是失败了。最终使用绝对路径

### <.bat> 批处理方式安装、启动和停止
     1. 原因一：我不会写客户端，而我有觉得与其把精力发在写客户端上，不如把文档写清晰，让更多人会用，用的灵活
     2. 原因二：灵活，用 <.bat> 批处理可一方便的改里面各个组件的版本，所以非常灵活
     3. 原因三：我做的只是我用的版本，包括组件的版本 64/32bit版本 包括测试的windows版本，所以我没做的，大家可以自行扩展

### Linux下 怎么安装 php + caddy

phpCaddy 是没有提供 linux 版本的，因为已经有大牛写了，抄过来不合适，所以请移步

1. 先安装 lamp，解压这步之后，先在 php.sh 里把 `--enable-fpm \` 添加进去，再进行安装

    然后在安装 php 扩展时 选择 redis 才会安装 redis 服务器，同时也会 安装 php_redis 扩展，会和 laravel 里的 Redis 类冲突，可以关闭

    https://lamp.sh/install.html

2. 再安装 caddy，php-fpm 默认是用 nobody 运行的，操作文件时可能会有权限问题，记得改权限

    https://doub.io/shell-jc1/

### 致敬一下 phpStudy

    我之前一直在 windows 下使用 phpStudy，也很感谢作者的分享

但有时受限于 phpStudy 里各个组件的版本，所以就自己弄了一个，加之又想尝试 caddy 又懒得在各个电脑重复配置，就搞了这个 **phpCaddy**，请勿见笑 23333~~

`phpCaddy` 不失为 `phpStudy` 之外的一个小选择
