#!/usr/bin/env bash

block="server {
    listen ${4:-80};
    listen ${5:-443} ssl;
    autoindex on;
    server_name $2;
    root \"$3\";

    add_header 		Access-Control-Allow-Origin *;
}
"

echo "$block" >> "/etc/nginx/sites/quickstead-$1"