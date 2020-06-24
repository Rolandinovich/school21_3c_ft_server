FROM debian:buster

LABEL maintainer="charmon@student.21-school.ru"

RUN apt-get update && apt-get install -y \
    nginx \
    mariadb-server mariadb-client \
    php php-fpm php-common php-mysql php-gd php-cli php-mbstring \
    wget

# Set up phpMyAdmin
RUN cd /tmp/ && wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz \
 && mkdir /var/www/ft_server \
 && mkdir /var/www/ft_server/phpmyadmin \
 && tar -C /var/www/ft_server/phpmyadmin -xvf phpMyAdmin-4.9.5-all-languages.tar.gz --strip 1 \
 && chown -R www-data:www-data /var/www/ft_server/phpmyadmin
COPY srcs/config.inc.php /var/www/ft_server/phpmyadmin

# Get and setup WordPress
RUN cd /tmp/ && wget https://wordpress.org/latest.tar.gz \
 && tar -C /var/www/ft_server/ -xvf latest.tar.gz \
 && chown -R www-data:www-data /var/www/ft_server/wordpress
COPY srcs/wp-config.php /var/www/ft_server/wordpress

# Set up NGINX
RUN mkdir -p /var/www/ft_server/html/ \
 && chown -R www-data:www-data /var/www/ft_server \
 && service nginx start
COPY srcs/ft_server_nginx /etc/nginx/sites-available/ft_server
RUN ln -s /etc/nginx/sites-available/ft_server /etc/nginx/sites-enabled/ \
 && rm /etc/nginx/sites-enabled/default
COPY srcs/index.html /var/www/ft_server/html/

# Generate a self-signed certificate and private key using OpenSSL
RUN cd /etc/ssl/certs/ \
 && openssl req -x509 -days 365 \
    -out ft_server.crt \
    -keyout ft_server.key \
    -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' \
 && chmod 775 /etc/ssl/certs/ft_server.key \
 && chmod 775 /etc/ssl/certs/ft_server.crt

#  Init database
COPY srcs/init_db.sh /scripts/
COPY srcs/wordpress_db.sql /root/
COPY srcs/phpmyadmin.sql /root/
RUN bash scripts/init_db.sh

EXPOSE 80 443

# Copy script to enable or disable autoindex
COPY srcs/switch_autoindex.sh /scripts/

# Start services
COPY srcs/entrypoint.sh /scripts/
ENTRYPOINT ["bash", "/scripts/entrypoint.sh"]