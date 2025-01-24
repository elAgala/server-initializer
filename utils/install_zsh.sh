#!/bin/bash

function install_zsh() {
  username=$1
  echo "[ UTILS ]: Installing zsh"
  sudo apt-get install -y zsh
  sudo chsh -s /usr/bin/zsh "$username"
  echo "[ UTILS ]: Zsh installed succesfully and set as default shell for $username"
}
