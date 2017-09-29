描述
====
这份脚本来自于 逗比根据地 https://doub.io/

使用方法参照： https://doub.io/shell-jc1/

系统要求
========
CentOS 6+ / Debian 6+ / Ubuntu 14.04 +

推荐 Debian 7 x64，这个是我一直使用的系统，我的脚本在这个系统上面出错率最低。


脚本版本
========
Ver: 1.0.6

本脚本只是一个一键安装+运行控制的脚本，没有其他管理虚拟主机等功能。


安装步骤
========
执行下面的代码安装 Caddy，默认给你们安装了 filemanager扩展（在线文件管理器/私人网盘），如果想要安装其他扩展可以把名字加到命令后面（bash caddy_install.sh install xxx,xxx,xxx，扩展列表看这里）。

```
wget -N --no-check-certificate https://softs.fun/Bash/caddy_install.sh && chmod +x caddy_install.sh && bash caddy_install.sh install http.filemanager
 
# 如果上面这个脚本无法下载，尝试使用备用下载：
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh && chmod +x caddy_install.sh && bash caddy_install.sh install http.filemanager
```


使用说明
========
启动：service caddy start

停止：service caddy stop

重启：service caddy restart

查看状态：service caddy status

查看Caddy启动日志： tail -f /tmp/caddy.log

安装目录：/usr/local/caddy

Caddy配置文件位置：/usr/local/caddy/Caddyfile

Caddy自动申请SSL证书位置：/.caddy/acme/acme-v01.api.letsencrypt.org/sites/xxx.xxx(域名)/


升级Caddy或者更新扩展
=====================
只需要重新执行你当初安装时候用的命令即可，会覆盖安装最新的Caddy+扩展（如有）


卸载Caddy
=========
卸载不会删除虚拟主机的内容，只会删除Caddy自身和配置文件。

```
wget -N --no-check-certificate https://softs.fun/Bash/caddy_install.sh && bash caddy_install.sh uninstall

# 如果上面这个脚本无法下载，尝试使用备用下载：
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh && bash caddy_install.sh uninstall
```
