#!/usr/bin/env bash

# 检测是否需要安装
if [ -f /home/vagrant/.env/mariadb55 ]
then
    exit 0
fi

# 清洁
sudo /bin/bash /home/vagrant/.remove/mysql.sh

# 安装 MariaDB
yum install -y mariadb-server maraidb-client mariadb-devel mariadb-common --enablerepo=mariadb-55

# 建立 环境标识
rm -rf /home/vagrant/.env/mysql*
rm -rf /home/vagrant/.env/mariadb*
touch /home/vagrant/.env/mariadb55

chkconfig mysql on
service mysql start

# 配置 MySQL 字符集
sed -i '/\[mysqld\]/acharacter_set_server=utf8' /etc/my.cnf.d/server.cnf

# 设置 MySQL 远程认证
sed -i '/\[mysqld\]/abind-address = 0.0.0.0' /etc/my.cnf.d/server.cnf

# 关闭 DNS 反查
# sed -i '$a skip-name-resolve' /etc/my.cnf

service mysql restart

mysql --user="root" -e "SET PASSWORD = PASSWORD('vagrant');"

service mysql restart

mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"

service mysql restart

mysql --user="root" --password="vagrant" -e "CREATE USER 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant';"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'localhost' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"
mysql --user="root" --password="vagrant" -e "drop DATABASE test;"

service mysql restart

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user="root" --password="vagrant" mysql