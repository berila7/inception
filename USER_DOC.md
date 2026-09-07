# User Documentation

## 1. Project Overview

Inception provides a WordPress website accessible through HTTPS.

The infrastructure contains:

- **NGINX**: Receives HTTPS requests.
- **WordPress**: Provides the website.
- **MariaDB**: Stores the website data.

## 2. Accessing the Website

Add the domain to your `/etc/hosts` file:

```text
10.0.2.15 mberila.42.fr
```

Then open the following address in a web browser:

```text
https://mberila.42.fr
```

Because the project uses a self-signed certificate, the browser may display a security warning. Accept the certificate warning to access the website.

## 3. WordPress Login

The WordPress administration page is available at:

```text
https://mberila.42.fr/wp-admin
```

Log in using the administrator credentials configured in the project secrets.

The administrator account is:

```text
owner
```

The password is stored in:

```text
secrets/wp_admin_password.txt
```

Do not share this password publicly.

## 4. WordPress Features

After logging in, the administrator can:

- Create and edit posts.
- Create and manage pages.
- Upload media.
- Manage comments.
- Manage users.
- Change website settings.
- Change the website appearance.
- Install and manage themes and plugins.

## 5. User Accounts

The project contains two WordPress users:

- Administrator: `owner`
- Secondary user: `student`

The administrator can manage the secondary user's permissions and account settings from the WordPress dashboard.

## 6. Starting the Project

From the project root, run:

```bash
make
```

This builds the Docker images and starts the infrastructure.

## 7. Stopping the Project

To stop and remove the containers, run:

```bash
make down
```

The website will no longer be accessible until the containers are started again.

## 8. Restarting the Project

To start the existing containers again, run:

```bash
make up
```

To rebuild the images and restart the complete infrastructure, run:

```bash
make re
```

## 9. Persistent Data

WordPress files and MariaDB data are stored on the host:

```text
/home/mberila/data/wordpress
/home/mberila/data/mariadb
```

This allows website content, users, and database information to remain available after the containers are stopped or recreated.

## 10. Full Cleanup

To remove the containers, Docker volumes, and persistent project data, run:

```bash
make fclean
```

This permanently deletes the stored WordPress and MariaDB data.

Use this command only when a complete reset is required.

## 11. Troubleshooting

### The website does not open

Check that the containers are running:

```bash
docker ps
```

If they are stopped, run:

```bash
make up
```

### The domain cannot be resolved

Check that `/etc/hosts` contains:

```text
10.0.2.15 mberila.42.fr
```

Replace the IP address if your machine uses another address.

### Check service logs

```bash
docker compose -f srcs/docker-compose.yml logs
```

To check one service:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

### The browser displays a certificate warning

The project uses a self-signed TLS certificate. This warning is expected during local development. Accept the certificate exception to continue to the website.

## 12. Important Notes

- Use HTTPS, not HTTP.
- Do not expose or share the passwords stored in the `secrets/` directory.
- Do not run `make fclean` unless you intend to delete the persistent website data.
- The website is available only while the Docker infrastructure is running.