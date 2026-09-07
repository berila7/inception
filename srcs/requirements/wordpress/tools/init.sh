#!/bin/sh

set -e

mkdir -p /var/www/html

echo "Waiting for MariaDB..."

DB_PASS=$(cat /run/secrets/db_password)

until mariadb \
    -h "$MYSQL_HOST" \
    -u "$MYSQL_USER" \
    -p"$DB_PASS" \
    -e "SELECT 1;" >/dev/null 2>&1
do
    sleep 2
done

echo "MariaDB is ready."

if [ ! -f "/var/www/html/index.php" ]; then
    echo "WordPress files not found. Downloading..."

    wp core download \
        --path=/var/www/html \
        --version=7.1 \
        --allow-root
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "WordPress configuration not found. Creating..."

    wp config create \
        --path=/var/www/html \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$MYSQL_HOST" \
        --allow-root
fi

if ! wp core is-installed \
    --path=/var/www/html \
    --allow-root
then
    echo "WordPress database not installed. Installing..."

    WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_password)

    wp core install \
        --path=/var/www/html \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
fi

if ! wp user get "$WP_USER" \
    --path=/var/www/html \
    --allow-root >/dev/null 2>&1
then
    echo "Creating secondary WordPress user..."

    WP_USER_PASS=$(cat /run/secrets/wp_user_password)

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=subscriber \
        --user_pass="$WP_USER_PASS" \
        --path=/var/www/html \
        --allow-root
fi

exec php-fpm8.2 -F