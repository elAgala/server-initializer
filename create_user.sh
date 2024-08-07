#!/bin/bash

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
