#!/bin/sh

set -e

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/server.crt ] || [ ! -f /etc/nginx/ssl/server.key ]; then
    echo "Generating TLS certificate..."
    
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/server.key \
        -out /etc/nginx/ssl/server.crt \
        -subj "/C=MA/ST=Casablanca/L=Casablanca/O=42/OU=Student/CN=$DOMAIN_NAME"

fi

exec nginx -g "daemon off;"