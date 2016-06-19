#!/usr/bin/env bash

yum remove -y mariadb mariadb-server mariadb-client mariadb-devel mariadb-common
yum remove -y MariaDB MariaDB-server MariaDB-client MariaDB-devel MariaDB-common
yum remove -y mysql mysql-server mysql-client mysql-devel mysql-common

rm -rf /var/lib/mysql/
rm -rf /var/log/mysqld.log
rm -rf /usr/lib64/mysql/plugin/
rm -rf /usr/share/mysql/