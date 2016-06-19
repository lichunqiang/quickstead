#!/usr/bin/env bash

block="server {
    listen ${4:-80};
    server_name $2;
    root $3;

    index index.php index.html index.htm;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/$1-error.log error;

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        try_files \$uri =404;
    }

    location ~ /\.(ht|svn|git) {
        deny all;
    }
}
"

echo "$block" >> "/etc/nginx/sites/quickstead-$1"
