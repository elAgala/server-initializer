#!/bin/bash

function create_deploy_user() {
  username="deploy"

  home_dir="/home/$username"

  echo "[ USER ]: Starting user $username setup"
  mkdir -p $home_dir
  sudo useradd $username
  echo "[ USER ]: Set a password for user [$username]:"
  sudo passwd $username
  echo "[ USER ]: User [deploy] created succesfully"

  echo "[ USER ]: Adding user to groups"
  sudo usermod -aG www-data $username
  sudo usermod -aG docker $username
  echo "[ USER ]: User added to the following groupps (www-data, docker)"

  echo "[ USER ]: Creating deploy folders under /home/$username"
  sudo mkdir -p /home/$username/static
  sudo mkdir -p /home/$username/apps

  echo "[ USER ]: Setting ownership of /home/$username folder"
  sudo chown -R $username:$username /home/$username
  echo "[ USER ]: User setup finished"
}
