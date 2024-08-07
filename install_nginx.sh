#!/bin/bash

# Function to create the static configuration template
function create_static_config() {
  cat << EOF > /etc/nginx/sites-available/static.example.conf
  server {
      listen 80;
      server_name (YOUR_DOMAINS);

      root (CONTENT_PATH);

      error_page 404 /;

      index index.html index.htm index.nginx-debian.html;

      location / {
          try_files $uri $uri/ =404;
      }
  }
  EOF
  echo "Created static configuration template: /etc/nginx/sites-available/static.example.conf"
}

# Function to create the API configuration template
function create_api_config() {
  cat << EOF > /etc/nginx/sites-available/api.example.conf
  server {
      listen 80;
      server_name YOUR_API_DOMAIN;
      location / {
          proxy_pass http://localhost:(API_PORT)/;
      }
  }
  EOF
  echo "Created API configuration template: /etc/nginx/sites-available/api.example.conf"
}

# Function to install Nginx
function install_nginx() {
  sudo apt update
  sudo apt install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx
}

install_nginx
create_api_config
create_static_config
sudo systemctl restart nginx

echo "To enable these configurations, create symbolic links to /etc/nginx/sites-enabled:"
