#!/bin/bash

# install nginx
sudo apt install nginx

# NOTE: if you get the error 
#	System has not been booted with systemd as init system (PID 1). Can't operate.
# substitute the systemctl command for service:
# systemctl <start|stop|restart|status> service_name	=> service service_name <start|stop|restart|status>

# make sure nginx starts after a reboot (on ubuntu it should anyway)
sudo update-rc.d nginx enable
#sudo systemctl enable nginx

# start nginx 
sudo service nginx start
#sudo systemctl start nginx

# NOTE: if nginx fails to start
#	* Starting nginx nginx		[fail]
# try the command 
# sudo nginx -t
# and fix any errors listed. i got:
# nginx: [emerg] bind() to 0.0.0.0:80 failed (13: Permission denied)
# either change the port nginx is listening on or i had to stop Skype and IIS

# check nginx is running 
sudo service nginx status
# sudo systemctl status nginx

# adjust the firewall to allow requests to nginx
sudo ufw app list
sudo ufw allow in "Nginx Full"