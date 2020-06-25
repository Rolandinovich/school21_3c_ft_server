#!/bin/bash
#
# Init database

wp_db_name='wordpress_db'
phpmyadmin_db_name='phpmyadmin'
username='admin'
userpassword='admin'
hostname='localhost'

# Start service
service mysql start

# Create database user
mysql -e "CREATE USER '$username'@'$hostname' IDENTIFIED BY '$userpassword'"

# phpMyAdmin database
mysql -e "CREATE DATABASE $phpmyadmin_db_name;"
mysql -e "GRANT ALL PRIVILEGES ON $phpmyadmin_db_name.* TO '$username'@'$hostname';"
mysql -e "FLUSH PRIVILEGES;"

# Wordpress database
mysql -e "CREATE DATABASE $wp_db_name;"
mysql -e "GRANT ALL PRIVILEGES ON $wp_db_name.* TO '$username'@'$hostname';"
mysql -e "FLUSH PRIVILEGES;"

# Restore backups
mysql $wp_db_name -u root < /root/wordpress_db.sql
mysql $phpmyadmin_db_name -u root < /root/phpmyadmin.sql
rm /root/wordpress_db.sql
