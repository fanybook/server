---
title: "12.配置过程 PHP"
date: 2017-09-24T17:58:08+08:00
menu: main
draft: false
---


### 一、下载

http://windows.php.net/download

     1. 选择 VC14 x64 Non Thread Safe (Zip)


### 二、安装

     1. 解压至 php
     2. 复制一个 php.ini-development 改名为 php.ini
     3. 修改 php.ini
     4. 启动。 <参考：启动套件.bat>

修改 php.ini

     1. 去掉这行前面的注释 extension_dir = "ext"
     2. 去掉这行前面的注释 cgi.fix_pathinfo=1
     3. session.save_path = "../tmp/session"
     4. 在最最后面添加
        [XDebug]
        xdebug.profiler_output_dir="../tmp/xdebug"
        xdebug.trace_output_dir="../tmp/xdebug"
     5. 在最最后面添加
        [XCache]
