#!/bin/bash

# create a server block for each website you need to host
# nginx has a server block enabled by default configured at /var/www/html
# this works for a single site but is no good for hosting multiple sites
# so create a new directory under /var/www for each new website you want to host 
# leave /var/www/html in place as the default site to be served if a request doesn’t match any others

# create the root directory for the new website
sudo mkdir /var/www/<new_website>

# assign ownership to the current system user
sudo chown -R $USER:$USER /var/www/<new_website>



