#!/bin/bash

function create_deploy_user() {
  local admin_user="$1"
  username="deploy"

  home_dir="/home/$username"

  echo "[ USER ]: Starting user $username setup"
  sudo useradd -m -s /bin/bash $username
  DEPLOY_USER_PASSWORD="${DEPLOY_PASSWORD:-$(openssl rand -base64 16)}"
  echo "$username:$DEPLOY_USER_PASSWORD" | sudo chpasswd
  echo "[ USER ]: Password set for $username (use DEPLOY_PASSWORD env var to specify)"
  echo "[ USER ]: User [deploy] created succesfully"

  echo "[ USER ]: Adding user to groups"
  sudo usermod -aG www-data $username
  echo "[ USER ]: User added to the following groups (www-data)"

  echo "[ USER ]: Creating deploy folders under /home/$username"
  sudo mkdir -p /home/$username/static
  sudo mkdir -p /home/$username/apps

  echo "[ USER ]: Setting ownership of /home/$username folder"
  sudo chown -R $username:$username /home/$username
  sudo chmod 750 /home/$username

  echo "[ USER ]: Adding $admin_user to deploy group"
  sudo usermod -aG deploy "$admin_user"

  echo "[ USER ]: Setting group-writable + setgid on apps/ and static/"
  sudo chmod 2775 /home/$username/apps
  sudo chmod 2775 /home/$username/static

  echo "[ USER ]: User setup finished"
}
