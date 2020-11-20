#!/bin/bash

# install php and some common extensions

# PHP 7.4 core
sudo apt install php7.4 php7.4-common php7.4-cli

# some extensions
sudo apt install php7.4-curl php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-xml

# web server integration
sudo apt install php7.4-fpm

# start php7.4-fpm
sudo service php7.4-fpm start
# sudo systemctl start php7.4-fpm

# make sure php starts on reboot
sudo systemctl enable php7.4-fpm

sudo service php7.4-fpm status