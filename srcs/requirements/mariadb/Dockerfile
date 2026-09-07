FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/* /var/lib/mysql/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY tools/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["/usr/local/bin/init.sh"]