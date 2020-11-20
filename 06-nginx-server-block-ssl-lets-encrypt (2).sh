#!/bin/bash

# install letsencrypt certbot and the nginx plugin
sudo apt install certbot python3-certbot-nginx

# get an SSL cert - follow the prompts 
sudo certbot --nginx -d website.com -d www.website.com
# sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email emailaddress@website.com -d website.com,www.website.com

# verify ssl certbot auto-Renewal - it'll check twice a day and renew any certificate that is within 30 days of expiring
sudo service certbot.timer status

# test it with a dry run
sudo certbot renew --dry-run

# open the nginx config file for website.com and add a block for ssl configuration below the non-ssl server {...} block
sudo nano /etc/nginx/sites-available/website.com

#======================================================================
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name website.com www.website.com;

    # reference the ssl cert requested above
    ssl_certificate /etc/letsencrypt/live/website.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/website.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/website.com/fullchain.pem;

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
        
    access_log /var/log/website.com.log;
    error_log /var/log/website.com.error.log;

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