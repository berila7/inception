#!/bin/sh

set -e

mkdir -p /var/www/html

if [ ! -f "/var/www/html/index.php" ]; then
    echo "WordPress files not found. Downloading..."

    wp core download \
        --path=/var/www/html \
        --version=7.1 \
        --allow-root
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "WordPress configuration not found. Creating..."

    DB_PASS=$(cat /run/secrets/db_password)

    wp config create \
        --path=/var/www/html \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$MYSQL_HOST" \
        --allow-root
fi

if ! HTTP_HOST="$DOMAIN_NAME" wp core is-installed \
    --path=/var/www/html \
    --allow-root
then
    echo "WordPress database not installed. Installing..."

    WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_password)

    HTTP_HOST="$DOMAIN_NAME" wp core install \
        --path=/var/www/html \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
fi

exec php-fpm8.2 -F