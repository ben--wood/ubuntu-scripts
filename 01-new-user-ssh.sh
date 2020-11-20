#!/bin/bash

# create a new user
adduser lempadmin

# grant admin privileges
usermod -aG sudo lempadmin

# want to access server using ssh keys
 
# create the key pair on your local machine
ssh-keygen
# give it a passphrase and save it somewhere 

# copy it to the server
ssh-copy-id lempadmin@<IP address of server>

# then access the server using ssh
ssh lempadmin@<IP address of server>

# disable password authentication on the server
# warning: make sure your account has admin privileges first as this will disable username/password access to the server
# edit the /etc/ssh/sshd_config file
sudo nano /etc/ssh/sshd_config

# uncomment this line 
#	PasswordAuthentication no

# restart ssh
sudo service ssh restart
# sudo systemctl restart ssh