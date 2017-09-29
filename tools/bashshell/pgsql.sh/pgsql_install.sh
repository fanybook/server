yum -y install gcc make readline zlib readline-devel zlib-devel
tar -jxvf postgresql-9.5.2.tar.bz2
cd postgresql-9.5.2
groupadd postgres
useradd -g postgres postgres
echo "dbking588" | passwd --stdin postgres
./configure --prefix=/opt/pg952
gmake world
gmake install-world
chown -R postgres:postgres /opt/pg952/
echo "export PG_HOME=/opt/pg952">> /home/postgres/.bash_profile
echo "export PG_DATA=/opt/pg952/data">> /home/postgres/.bash_profile
echo "export LD_LIBRARY_PATH=$PG_HOME/lib:$LD_LIBRARY_PATH">> /home/postgres/.bash_profile
echo "export PATH=PG_HOME/bin:$PATH">> /home/postgres/.bash_profile
/opt/pg952/bin/initdb -D /opt/pg952/data/ --locale=C --encoding=UTF8
/opt/pg952/bin/pg_ctl -D /opt/pg952/data/ -l /opt/pg952/logfile start
--创建数据库/用户：
postgres=# create user root superuser;
CREATE ROLE
postgres=# create database root;
CREATE DATABASE