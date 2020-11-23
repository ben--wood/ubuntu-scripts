#!/bin/bash

# get the download location of WordPress from https://wordpress.org/download/ - it'll probably be something like https://wordpress.org/latest.zip
wget https://wordpress.org/latest.zip

sudo apt install unzip

# unzip it
sudo unzip latest.zip -d /var/www/website.com

# it unzips into a WordPress sub-directory so move everything up and delete that WordPress directory
sudo mv -v /var/www/website.com/wordpress/* /var/www/website.com/
sudo rm /var/www/website.com/wordpress/

# create a database for WordPress 
# login to mariadb
sudo mariadb -u root

# create a database with a name of website-wp-db
create database website-wp-db;

# this will create a user (website-wp-user) and give them privileges in the new db
grant all privileges on website-wp-db.* to website-wp-user@localhost identified by '<strong password>';

flush privileges;
exit;


# now tell WordPress to use the new db
cd /var/www/website.com/

# the unzipped WordPress archive contains a sample config file wp-config-sample.php
sudo nano wp-config-sample.php

# update the DB_NAME, DB_USER and DB_PASSWORD values 
## define('DB_NAME', 'website-wp-db');
## define('DB_USER', 'website-wp-user');
## define('DB_PASSWORD', '<strong password>');
# save and close the file - in nano Ctrl+O, Enter, Ctrl+X

# rename the sample config file to the actual config file
sudo mv wp-config-sample.php wp-config.php


# then you should be able to steup WordPress by browsing to https://www.website.com/wp-admin/install.php