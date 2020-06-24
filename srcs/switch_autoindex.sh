#!/bin/bash

nginx_conf='/etc/nginx/sites-available/ft_server'
is_on='autoindex on;'
is_off='autoindex off;'

# Check param is correct
if [[ "$1" =~ ^(on|ON|off|OFF)$ ]]
then
    if grep -q "$is_on" "$nginx_conf"
    then
        if [[ "$1" = "off" || "$1" = "OFF" ]]
        then
            sed -i "s/$is_on/$is_off/g" "$nginx_conf"
            echo "autoindex turn off"
        fi
    elif grep -q "$is_off" "$nginx_conf"
    then
        if [[ "$1" = "on" || "$1" = "ON" ]]
        then
            sed -i "s/$is_off/$is_on/g" "$nginx_conf"
            echo "autoindex turn on"
        fi
    fi
    service nginx restart
    exit 0
else
  echo "incorrect argument"
fi
