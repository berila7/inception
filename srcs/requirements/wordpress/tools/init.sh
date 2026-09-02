#!/bin/sh

set -e

mkdir -p /var/www/html

if [ ! -f "/var/www/html/wp-config.php" ]; then

    echo "WordPress files not found. Installing..."

    if [ ! -f "/var/www/html/index.php" ]; then
        wp core download \
            --path=/var/www/html \
            --version=7.1 \
            --allow-root

    fi

    DB_PASS=$(cat /run/secrets/db_password)

    wp config create \
        --path=/var/www/html \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$MYSQL_HOST" \
        --allow-root
fi

exec php-fpm8.2 -F