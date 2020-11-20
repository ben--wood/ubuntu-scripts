#!/bin/bash

# get the download location of WordPress from https://wordpress.org/download/ - it'll probably be something like https://wordpress.org/latest.zip
wget https://wordpress.org/latest.zip

sudo apt install unzip

# unzip it
sudo unzip latest.zip -d /var/www/website.com

# it creates a WordPress directory so move everything up and delete that WordPress directory
sudo mv -v /var/www/website.com/wordpress/* /var/www/website.com/
sudo rm /var/www/website.com/wordpress/

# TODO: create db, wp-config.php, give nginx ownership of /var/www/website.com