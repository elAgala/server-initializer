#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt install -y curl gnupg lsb-release

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install PM2
sudo npm install -g pm2

# Install Nginx
sudo apt install -y nginx

# Create files and directories
sudo mkdir -p /var/www/myapp
sudo touch /var/www/myapp/index.html
sudo ln -s /var/www/myapp /var/www/html/myapp

# Set up default Nginx config
cat <<EOF | sudo tee /etc/nginx/sites-available/default
server {
    listen 80;
    server_name myserver.com;

    root /var/www/myapp;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Restart Nginx to apply changes
sudo systemctl restart nginx
