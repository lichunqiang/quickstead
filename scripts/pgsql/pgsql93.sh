#!/usr/bin/env bash

# 检测是否需要安装
if [ -f /home/vagrant/.env/pgsql93 ]
then
    exit 0
fi

# 清洁
sudo /bin/bash /home/vagrant/.remove/pgsql.sh

# 安装 Postgres
yum install -y postgresql93 postgresql93-server postgresql93-devel postgresql93-contrib --enablerepo=pgdg93

# 建立 环境标识
rm -rf /home/vagrant/.env/pgsql*
touch /home/vagrant/.env/pgsql93

/usr/pgsql-9.3/bin/postgresql93-setup initdb
systemctl enable postgresql-9.3.service
systemctl start postgresql-9.3.service

# 配置 Postgres 远程访问
sed -i "/#listen_addresses/alisten_addresses = '*'" /var/lib/pgsql/9.3/data/postgresql.conf
echo "host    all             all             10.0.2.2/32               md5" | tee -a /var/lib/pgsql/9.3/data/pg_hba.conf
sudo -i -u postgres psql -c "CREATE ROLE vagrant LOGIN UNENCRYPTED PASSWORD 'vagrant' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

systemctl restart postgresql-9.3.service