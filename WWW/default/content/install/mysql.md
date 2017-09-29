---
title: "13.配置过程 MySQL"
date: 2017-09-24T17:58:08+08:00
menu: main
draft: false
---


### 一、下载

https://dev.mysql.com/downloads/mysql/

     1.选择 winx64.zip


### 二、精简

     1. mysql 中仅保留 bin、lib 和 share 三个子目录，其他子目录及文件全部删除
     2. bin 目录下仅保留 mysqld.exe、mysqladmin.exe和 mysql.exe 三个文件，其他子目录及文件全部删除
     3. lib 目录下保留 libmysql.dll 和 libmysql.lib 两个文件，其他子目录及文件全部删除
     4. share 目录下仅保留 charsets 和 english 两个子目录，其他子目录及文件全部删除


### 三、安装

     1. mysql 的路径中不要出现汉字
     2. 在 mysql 目录  新建 my.ini 文件
     3. 初始化 mysql 和设置 mysql 的用户名、密码 <参考：@安装.bat [`:install` 之后才是有效代码]>
     4. 启动 <参考：启动套件.bat>

my.ini 的配置

```php
[client]
port=3306

#新版不支持在my.ini中直接设置字符集为utf8。解决方法是在default-character-set前面加上loose-
loose-default-character-set = utf8

[mysqld]
port=3306

#写了如果要远程访问 <参考：四、备忘>
bind-address=0.0.0.0

#路径相对于 <安装和启动的 .bat>
basedir="./mysql5.7/"
datadir="./mysql5.7/data/"

loose-default-character-set = utf8
character-set-server=utf8

#默认是innodb
#default-storage-engine=MyISAM

#减少一点data文件夹的体积
innodb_log_file_size=24M
```


### 四、备忘

设置远程连接

    mysql> use mysql
    mysql> Grant all on *.* to 'root'@'%' identified by 'root用户的密码' with grant option;
    mysql> flush privileges;

mysqld.exe -install Mysql57

    mysqld.exe -install 可以把 mysql 添加为系统服务

    -install后面加 Mysql57 可以控制要添加的系统服务 “名字”

mysqld.exe -remove Mysql57

    mysqld.exe -remove 可以把 mysql 系统服务移除

    -remove后面加 Mysql57 可以控制要移除的系统服务 “名字”，包括其他非 mysql 的服务

    这个命令也行：开始->运行->输入cmd->sc delete mysql


### 五、参考
http://www.cnblogs.com/live41/p/3971518.html

phpStudy 的 my.ini
```php
#  power by phpStudy  2014  www.phpStudy.net  官网下载最新版

[client]
port=3306
[mysql]
default-character-set=utf8

[mysqld]
port=3306
basedir="D:/phpStudy/MySQL/"
datadir="D:/phpStudy/MySQL/data/"
character-set-server=utf8
default-storage-engine=MyISAM
#支持 INNODB 引擎模式。修改为　default-storage-engine=INNODB　即可。
#如果 INNODB 模式如果不能启动，删除data目录下ib开头的日志文件重新启动。

sql-mode="NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
max_connections=512

query_cache_size=0
table_cache=256
tmp_table_size=18M

thread_cache_size=8
myisam_max_sort_file_size=64G
myisam_sort_buffer_size=35M
key_buffer_size=25M
read_buffer_size=64K
read_rnd_buffer_size=256K
sort_buffer_size=256K

innodb_additional_mem_pool_size=2M

innodb_flush_log_at_trx_commit=1
innodb_log_buffer_size=1M

innodb_buffer_pool_size=47M
innodb_log_file_size=24M
innodb_thread_concurrency=8
```
