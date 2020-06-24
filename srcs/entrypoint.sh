#!/bin/bash
#
# Start services

service nginx restart \
&& service php7.3-fpm start \
&& service mysql restart

# Display real time server logs
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
