#!/bin/bash

function create_deploy_user() {
  username="deploy"
  echo "[ USER ]: Starting user $usernname setup"
  sudo useradd $username
  echo "[ USER ]: Set a password for user [$username]:"
  sudo passwd $username
  echo "[ USER ]: User [deploy] created succesfully"

  echo "[ USER ]: Adding user to groups"
  sudo usermod -aG www-data $username
  sudo usermod -aG docker $username
  echo "[ USER ]: User added to the following groupps (www-data, docker)"

  echo "[ USER ]: Setting ownership of /home/$username folder"
  sudo chown -R $username:$username /home/$username

  echo "[ USER ]: User setup finished"
}
