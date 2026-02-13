#!/bin/bash

function create_user() {
  username=$1

  home_dir="/home/$username"

  echo "[ USER ]: Starting user $username setup"
  mkdir -p $home_dir
  sudo useradd $username
  password="${ADMIN_PASSWORD:-$(openssl rand -base64 16)}"
  echo "$username:$password" | sudo chpasswd
  echo "[ USER ]: Password set for $username (use ADMIN_PASSWORD env var to specify)"
  echo "[ USER ]: User created succesfully"

  echo "[ USER ]: Adding user to groups"
  sudo usermod -aG sudo $username
  sudo usermod -aG www-data $username
  echo "[ USER ]: User added to the following groups (sudo, www-data)"

  echo "[ USER ]: Setting ownership of /home/$username folder"
  sudo chown -R $username:$username /home/$username

  echo "[ USER ]: User setup finished"
}
