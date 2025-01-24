#!/bin/bash

function install_zsh() {
  username=$1

  echo "[ UTILS ]: Installing Zsh"
  sudo apt-get install -y zsh
  # Set Zsh as the default shell for the user
  sudo chsh -s /usr/bin/zsh "$username"
  echo "[ UTILS ]: Installing Oh My Zsh for $username"
  # Install Oh My Zsh
  sudo -u "$username" sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -) --unattended"
  echo "[ UTILS ]: Zsh and Oh My Zsh installed successfully and set as the default shell for $username"
}
