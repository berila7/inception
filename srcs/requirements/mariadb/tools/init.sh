#!/bin/sh
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db > /dev/null
    DB_PASS=$(cat /run/secrets/db_password)
    DB_ROOT_PASS=$(cat /run/secrets/db_root_password)

cat > /tmp/init.sql <<EOF
FLUSH PRIVILEGES;
DELETE FROM mysql.global_priv WHERE User='';
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
FLUSH PRIVILEGES;
EOF
    mysqld --user=mysql --bootstrap < /tmp/init.sql
    rm -f /tmp/init.sql
    
fi

exec mysqld --user=mysql