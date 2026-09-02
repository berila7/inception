FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-cli \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && php /tmp/wp-cli.phar --info \
    && chmod +x /tmp/wp-cli.phar \
    && mv /tmp/wp-cli.phar /usr/local/bin/wp

COPY tools/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["/usr/local/bin/init.sh"]