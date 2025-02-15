#!/bin/bash

function setup_ufw() {
  echo "[ WEB ]: Started UFW Firewall setup"
  sudo apt-get install -y ufw
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow 22/tcp
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo ufw enable
  echo "[ WEB ]: UFW Installed succesfully. Open ports SSH:22 - HTTPS:443 - HTTP:80"
}
