# Developer Documentation

## 1. Project Overview

Inception is a Docker-based infrastructure composed of three services:

- **NGINX**
- **WordPress**
- **MariaDB**

The services are managed with Docker Compose and communicate through a dedicated Docker network.

## 2. Project Structure

```text
inception/
├── Makefile
├── README.md
├── DEV_DOC.md
├── .env
├── secrets/
│   ├── db_password.txt
│   ├── db_root_password.txt
│   └── wp_admin_password.txt
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        └── nginx/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

## 3. Services

### 3.1 NGINX

NGINX is the public entrypoint of the infrastructure.

Responsibilities:

- Accept HTTPS connections on port 443.
- Use the configured TLS certificate and private key.
- Serve WordPress files.
- Forward PHP requests to the WordPress container through PHP-FPM.
- Redirect WordPress requests internally to `index.php` when required.

NGINX communicates with WordPress using:

```text
wordpress:9000
```

### 3.2 WordPress

WordPress runs with PHP-FPM.

Responsibilities:

- Install and configure WordPress.
- Connect to MariaDB.
- Create the WordPress database configuration.
- Create the administrator and secondary user.
- Serve PHP requests through PHP-FPM on port 9000.

WordPress communicates with MariaDB using the Docker service name:

```text
mariadb
```

### 3.3 MariaDB

MariaDB provides the database used by WordPress.

Responsibilities:

- Initialize the database.
- Create the WordPress database.
- Create the WordPress database user.
- Set the root password.
- Start the MariaDB server.

MariaDB listens on the internal Docker network and is not published directly to the host.

## 4. Docker Compose

The Docker Compose file is located at:

```text
srcs/docker-compose.yml
```

It defines:

- The three services.
- Custom image names and tags.
- Build contexts and Dockerfiles.
- Container dependencies.
- Healthchecks.
- Docker secrets.
- Environment variables.
- Persistent bind-mounted volumes.
- The custom Docker network.
- The HTTPS port mapping.

The only published port is:

```text
443:443
```

## 5. Network

All services are connected to the custom network:

```text
inception
```

Containers communicate using service names:

- `mariadb`
- `wordpress`
- `nginx`

The network allows internal service communication without exposing MariaDB or PHP-FPM directly to the host.

## 6. Persistent Data

Persistent data is stored on the host using bind mounts.

**MariaDB data**

```text
/home/mberila/data/mariadb
```

**WordPress data**

```text
/home/mberila/data/wordpress
```

The data remains available after containers are stopped or recreated.

Removing the containers does not remove the host directories unless they are explicitly deleted.

## 7. Secrets and Environment Variables

Sensitive values are stored in Docker secrets:

```text
/run/secrets/db_password
/run/secrets/db_root_password
/run/secrets/wp_admin_password
/run/secrets/wp_user_password
```

Non-sensitive configuration is stored in the `.env` file.

Examples include:

```env
DOMAIN_NAME=mberila.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_HOST=mariadb
WP_TITLE=Inception
WP_ADMIN_USER=owner
WP_USER=student
```

Passwords are not written directly into Dockerfiles or the Compose file.

## 8. Initialization Process

### MariaDB initialization

The MariaDB initialization script:

- Reads the database passwords from Docker secrets.
- Creates the database if it does not already exist.
- Creates the WordPress database user.
- Grants the required permissions.
- Starts MariaDB.

### WordPress initialization

The WordPress initialization script:

- Waits until MariaDB is ready.
- Downloads or prepares WordPress files.
- Creates the WordPress configuration.
- Installs WordPress using WP-CLI.
- Creates the administrator account.
- Creates the secondary user.
- Starts PHP-FPM in the foreground.

## 9. NGINX Configuration

NGINX is configured to:

- Listen on port 443.
- Use TLS 1.2 and TLS 1.3.
- Serve files from `/var/www/html`.
- Use `index.php` as the default index.
- Forward PHP requests to `wordpress:9000`.

The main request flow is:

```text
Client
  |
  | HTTPS :443
  v
NGINX
  |
  | FastCGI
  v
WordPress PHP-FPM
  |
  | Database connection
  v
MariaDB
```

## 10. PHP-FPM Configuration

PHP-FPM listens on:

```text
0.0.0.0:9000
```

The WordPress container runs PHP-FPM in the foreground so Docker can track the main process.

The configured process manager is dynamic, with limits defined in the PHP-FPM pool configuration.

## 11. Makefile Commands

Run commands from the project root.

**Build and start**

```bash
make
```

**Build images**

```bash
make build
```

**Start containers**

```bash
make up
```

**Stop and remove containers**

```bash
make down
```

**Clean Docker resources**

```bash
make clean
```

**Full cleanup**

```bash
make fclean
```

**Rebuild the project**

```bash
make re
```

## 12. Useful Debugging Commands

**List containers**

```bash
docker ps
```

**View all containers**

```bash
docker ps -a
```

**View images**

```bash
docker images
```

**View service logs**

```bash
docker compose -f srcs/docker-compose.yml logs
```

**View logs for one service**

```bash
docker compose -f srcs/docker-compose.yml logs mariadb
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs nginx
```

**Inspect the network**

```bash
docker network inspect inception
```

**Enter a running container**

```bash
docker exec -it <container_name> bash
```

**Check the website**

```bash
curl -k -I https://mberila.42.fr
```

## 13. Rebuilding and Persistence Test

To verify persistence:

1. Create or modify WordPress data.
2. Stop the infrastructure:

   ```bash
   make down
   ```

3. Start it again:

   ```bash
   make up
   ```

4. Confirm that the WordPress users and website data are still present.

The data is preserved because it is stored in host bind-mounted directories.

## 14. Security Considerations

- HTTPS is used for external access.
- Only port 443 is exposed.
- MariaDB is not exposed directly to the host.
- Passwords are stored using Docker secrets.
- Containers communicate through an isolated Docker network.
- The WordPress administrator username is not named `admin`.
- TLS protocols are restricted to TLS 1.2 and TLS 1.3.

## 15. Maintenance

When changing configuration:

1. Edit the relevant Dockerfile, configuration file, or initialization script.
2. Rebuild the affected image:

   ```bash
   make build
   ```

3. Recreate the containers:

   ```bash
   make down
   make up
   ```

4. Check the logs:

   ```bash
   docker compose -f srcs/docker-compose.yml logs
   ```

5. Test HTTPS access:

   ```bash
   curl -k -I https://mberila.42.fr
   ```