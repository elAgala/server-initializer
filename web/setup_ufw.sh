#!/bin/bash

function setup_ufw() {
  echo "[ WEB ]: Started UFW Firewall setup"
  sudo apt-get install -y ufw
  sudo ufw allow 22
  sudo ufw allow 443
  sudo ufw enable
  echo "[ WEB ]: UFW Installed succesfully. Open ports SSH:22 - HTTPS:443"
}
