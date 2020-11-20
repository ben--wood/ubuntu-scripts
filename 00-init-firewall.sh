#!/bin/bash

# update and upgrade 
sudo apt update
sudo apt upgrade

# install the firewall (ubuntu should have it already)
sudo apt install ufw

# see apps that can be configured with ufw
sudo ufw app list

# allow SSH connections
sudo ufw allow OpenSSH

# and enable the firewall
sudo ufw enable