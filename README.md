*This project has been created as part of the 42 curriculum by mberila.*

# Inception

## Description

Inception is a system administration project focused on Docker and containerization.

The project builds a small infrastructure composed of three services:

- **NGINX**: HTTPS entrypoint and reverse proxy.
- **WordPress**: Website running with PHP-FPM.
- **MariaDB**: Database used by WordPress.

Each service runs in its own container. The containers communicate through a dedicated Docker network, and persistent data is stored on the host.

### Main design choices

- **Dockerfiles** are used to build custom images for each service.
- **Docker Compose** is used to create and manage the infrastructure.
- **Docker secrets** are used for passwords and other sensitive values.
- A **`.env` file** is used for non-sensitive configuration.
- **volumes** keep WordPress and MariaDB data persistent on the host.
- **HTTPS** is enabled in NGINX using TLS certificates.
- The services communicate using Docker service names instead of hard-coded container IP addresses.

### Main comparisons

#### Virtual Machines vs Docker

Virtual machines include a complete guest operating system and require more resources. Docker containers share the host kernel, start faster, and use fewer resources while still providing process isolation.

#### Secrets vs Environment Variables

Environment variables are useful for normal configuration, but sensitive values can be exposed through process information or container inspection. Docker secrets are intended for confidential data such as database passwords.

#### Docker Network vs Host Network

A Docker network provides isolated communication between containers and allows services to reach each other by service name. Host networking removes this network isolation and makes containers use the host's network directly.

#### Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker and are portable between containers. Bind mounts map specific host directories into containers, giving direct control over where persistent data is stored.

## Instructions

### Requirements

- Docker
- Docker Compose
- A configured domain entry for `mberila.42.fr`

Add the following line to `/etc/hosts`:

```text
10.0.2.15 mberila.42.fr
```

Replace the IP address if your local machine uses another IP.

### Build and start the infrastructure

From the project root:

```bash
make
```

Build the images:

```bash
make build
```

Start the containers:

```bash
make up
```

Stop and remove the containers:

```bash
make down
```

Clean the Docker resources:

```bash
make clean
```

Full cleanup:

```bash
make fclean
```

This also removes the persistent data stored in:

```text
/home/mberila/data/wordpress
/home/mberila/data/mariadb
```

Rebuild everything:

```bash
make re
```

The website is available at:

```text
https://mberila.42.fr
```

## Resources

- Docker documentation
- Docker Compose documentation
- NGINX documentation
- MariaDB documentation
- WordPress documentation
- WP-CLI documentation

AI was used to help understand Docker concepts, troubleshoot configuration issues, review configuration files and scripts. All project components were tested and reviewed manually.