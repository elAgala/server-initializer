#!/bin/bash

function install_make() {
  echo "[ UTILS ]: Installing Make"
  sudo apt update
  sudo apt install build-essential
  echo "[ UTILS ]: Make installed succesfully"
}
