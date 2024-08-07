#!/bin/bash

echo "Installing and setting up nginx"

# Function to create the static configuration template
function create_static_config() {
  cat <<EOF | sudo tee /etc/nginx/sites-available/static.example.conf
server {
    listen 80;
    server_name YOUR_DOMAINS;

    root CONTENT_PATH;

    error_page 404 /;

    index index.html index.htm index.nginx-debian.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
  echo "Created static configuration template: /etc/nginx/sites-available/static.example.conf"
}

# Function to create the API configuration template
function create_api_config() {
  cat <<EOF | sudo tee /etc/nginx/sites-available/api.example.conf
server {
    listen 80;
    server_name YOUR_API_DOMAIN;
    location / {
        proxy_pass http://localhost:API_PORT/;
    }
}
EOF
  echo "Created API configuration template: /etc/nginx/sites-available/api.example.conf"
}

# Function to install Nginx
function install_nginx() {
  if ! dpkg -l | grep -q nginx; then
    sudo apt update
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
  else
    echo "Nginx is already installed."
  fi
}

install_nginx
create_api_config
create_static_config
sudo systemctl restart nginx

# Enable Nginx configurations
sudo ln -s /etc/nginx/sites-available/static.example.conf /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/api.example.conf /etc/nginx/sites-enabled/

echo "To enable these configurations, symbolic links have been created in /etc/nginx/sites-enabled."

echo "Installing and setting up Docker"

# Install prerequisites
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Create directory for GPG key
sudo mkdir -p /etc/apt/keyrings

# Download and install Docker GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to sources.list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Update package lists
sudo apt-get update

# Install Docker Engine, CLI, containerd, Buildx plugin, and Compose plugin
if ! dpkg -l | grep -q docker-ce; then
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  echo "Docker installation completed!"
else
  echo "Docker is already installed."
fi

echo "New user creation"

function create_user() {
  read -p "Enter username: " username

  sudo useradd -m -d /home/$username $username
  sudo usermod -aG sudo $username

  sudo mkdir -p /var/www/apps /var/www/static

  echo "User $username created with sudo privileges"
  echo "Apps directory created: /var/www/apps/"
  echo "Static files directory: /var/www/static"
  echo "Next step: Create SSH keys. Refer to: [link to SSH key creation guide]"
}

create_user
