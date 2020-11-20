#!/bin/bash

# mariadb or mysql
sudo apt install mariadb-server mariadb-client
# sudo apt install mysql-server

sudo service mysql start 
# you might need 
# sudo service mysqld start 
# sudo service mariadb start 

sudo service mysql status

sudo mysql_secure_installation
# set a root password and accept all defaults after that

# login to db using passthrough authentication
sudo mariadb -u root
exit;

mariadb --version