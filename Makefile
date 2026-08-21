COMPOSE		=	docker compose -f srcs/docker-compose.yml
DIR			=	/home/mberila/data

all:
	mkdir -p $(DIR)/wordpress
	mkdir -p $(DIR)/mariadb
	$(COMPOSE) up -d --build

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	sudo rm -rf $(DIR)
	docker system prune -af

re: fclean all

.PHONY: all build up down clean fclean re