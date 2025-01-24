#!/bin/bash

function install_vim() {
  # TODO: Add .config

  echo "[ UTILS ]: Installing Vim"
  sudo apt-get install -y vim
  echo "[ UTILS ]: Vim installed succesfully"
}
