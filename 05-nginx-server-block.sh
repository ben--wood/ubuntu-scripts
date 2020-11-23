#!/bin/bash

# create a server block for each website you need to host
# nginx has a server block enabled by default configured at /var/www/html
# this works for a single site but is no good for hosting multiple sites
# so create a new directory under /var/www for each new website you want to host 
# leave /var/www/html in place as the default site to be served if a request doesn’t match any others

# create the root directory for the new website
sudo mkdir /var/www/website.com

# give nginx ownership of the new directory
sudo chown www-data:www-data /var/www/website.com/ -R

# create a new config file here (in nano to save and close the file: CTRL+X then y and ENTER)
sudo nano /etc/nginx/sites-available/website.com

#======================================================================
server {
    listen 80;
    listen [::]:80;

    # urls for your website
    server_name website.com www.website.com;
    
    # where the files for your website live
    root /var/www/website.com;

    # the default documents nginx will look for when someone visits your site
    index index.html index.php;

    location / {
        try_files $uri $uri/ =404; # return 404 error if can't match the request
    }

    location = /favicon.ico {
            log_not_found off;
            access_log off;
    }

    location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_intercept_errors on;
        fastcgi_pass php;        
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    #enable gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1000;
    gzip_comp_level 5;
    gzip_types application/json text/css application/x-javascript application/javascript image/svg+xml;
    gzip_proxied any;

    # define a long browser cache 
    location ~* \.(jpg|jpeg|gif|png|webp|svg|woff|woff2|ttf|css|js|ico|xml)$ {
        access_log off;
        log_not_found off;
        expires max;
    }

    # a couple of things to attempt to prevent cross-site scripting
    add_header X-XSS-Protection "1; mode=block";
    add_header Content-Security-Policy "default-src 'self'; script-src 'self';";
    add_header Referrer-Policy "no-referrer"; # no referrer header 
    add_header X-Frame-Options "SAMEORIGIN" always; # tries to force the webpage to only be displayed on the same origin (domain) as itself

    location ~ /\.ht {
        deny all; # don't want to serve up .htaccess to visitors
    }
}
#======================================================================

# link the new config to nginx sites-enabled directory to activate the configuration
sudo ln -s /etc/nginx/sites-available/website.com /etc/nginx/sites-enabled/

# test the configuration
sudo nginx -t

# reload nginx 
sudo service nginx reload