#!/bin/bash

function install_nginx() {
  echo "[ WEB ]: Starting NginX setup"
  if ! dpkg -l | grep -q nginx; then
    sudo apt update
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "[ WEB ]: Installed NginX succesfully"
  else
    echo "[ WEB ]: NginX already installed, skipping..."
  fi
}
