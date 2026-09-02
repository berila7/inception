#!/bin/sh

set -e

mkdir -p /var/www/html

if [ ! -f "/var/www/html/index.php" ]; then

    echo "WordPress files not found. Installing..."

fi