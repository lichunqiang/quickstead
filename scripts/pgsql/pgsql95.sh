#!/usr/bin/env bash

# 检测是否需要安装
if [ -f /home/vagrant/.env/pgsql95 ]
then
    exit 0
fi

# 清洁
sudo /bin/bash /home/vagrant/.remove/pgsql.sh

# 安装 Postgres
yum install -y postgresql95 postgresql95-server postgresql95-devel postgresql95-contrib --enablerepo=pgdg95

# 建立 环境标识
rm -rf /home/vagrant/.env/pgsql*
touch /home/vagrant/.env/pgsql95

/usr/pgsql-9.5/bin/postgresql95-setup initdb
systemctl enable postgresql-9.5.service
systemctl start postgresql-9.5.service

# 配置 Postgres 远程访问
sed -i "/#listen_addresses/alisten_addresses = '*'" /var/lib/pgsql/9.5/data/postgresql.conf
echo "host    all             all             10.0.2.2/32               md5" | tee -a /var/lib/pgsql/9.5/data/pg_hba.conf
sudo -i -u postgres psql -c "CREATE ROLE vagrant LOGIN UNENCRYPTED PASSWORD 'vagrant' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

systemctl restart postgresql-9.5.service