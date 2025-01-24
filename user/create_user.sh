#!/bin/bash

function create_user() {
  username=$1

  echo "[ USER ]: Starting user setup"
  sudo useradd $username
  echo "[ USER ]: Set a password for $username:"
  sudo passwd "$username"
  echo "[ USER ]: User created succesfully"

  echo "[ USER ]: Adding user to groups"
  sudo usermod -aG sudo $username
  sudo usermod -aG www-data $username
  sudo usermod -aG docker $username
  echo "[ USER ]: User added to the following groupps (sudo, www-data, docker)"

  echo "[ USER ]: User setup finished"
}
