#!/usr/bin/env bash

# 检测是否需要安装
if [ -f /home/vagrant/.env/mysql55 ]
then
    exit 0
fi

# 清洁
sudo /bin/bash /home/vagrant/.remove/mysql.sh

# 安装 MySQL
yum install -y mysql mysql-client mysql-server mysql-devel --enablerepo=mysql55-community

# 建立 环境标识
rm -rf /home/vagrant/.env/mysql*
rm -rf /home/vagrant/.env/mariadb*
touch /home/vagrant/.env/mysql55

systemctl enable mysqld.service
systemctl start mysqld.service

# 配置 MySQL 字符集
sed -i '/\[mysqld\]/a character_set_server=utf8' /etc/my.cnf

# 设置 MySQL 远程认证
sed -i '/\[mysqld\]/a bind-address = 0.0.0.0' /etc/my.cnf

# 关闭 DNS 反查
# sed -i '$a skip-name-resolve' /etc/my.cnf

systemctl restart mysqld.service

mysql --user="root" -e "SET PASSWORD = PASSWORD('vagrant');"

systemctl restart mysqld.service

mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"

mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'localhost' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"
mysql --user="root" --password="vagrant" -e "drop DATABASE test;"

systemctl restart mysqld.service

# 添加 MySQL 时区支持
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user="root" --password="vagrant" mysql