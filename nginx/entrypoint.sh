#!/bin/bash

sed -i "s/HOST_ID/$HOSTNAME/" /usr/share/nginx/html/index.html

nginx -g "daemon off;"
