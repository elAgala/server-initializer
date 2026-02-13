#!/bin/bash

function install_make() {
  echo "[ UTILS ]: Installing Make"
  sudo apt update
  sudo apt install -y make
  echo "[ UTILS ]: Make installed succesfully"
}
