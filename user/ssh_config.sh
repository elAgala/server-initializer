#!/bin/bash

function config_ssh() {
  username=$1

  echo "[ SSH ]: Starting setup"
  ssh_dir="/home/$username/.ssh"

  sudo mkdir -p $ssh_dir
  sudo chmod 700 $ssh_dir

  sudo touch "$ssh_dir/authorized_leys"
  sudo chmod 600 "$ssh_dir/authorized_leys"
  sudo chown -R "$username:$username" $ssh_dir
  echo "[ SSH ]: Created ~/.ssh/authorized_leys"

  echo "[ SSH ]: Paste the public key for $username (leave empty to skip)"
  read -r public_key
  if [ -n "$public_key" ]; then
    echo "$public_key" | sudo tee -a "$ssh_dir/authorized_keys" >/dev/null
    echo "[ SSH ]: Public key added to $ssh_dir/authorized_keys."
  else
    echo "[ SSH ]: No public key provided, skipping..."
  fi

  echo "[ SSH ]: Disabling root login"
  sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
  echo "[ SSH ]: Root login disabled"

  echo "[ SSH ]: Adding $username to allowed users"
  if grep -q "^AllowUsers" /etc/ssh/sshd_config; then
    sudo sed -i "s/^AllowUsers.*/& $username/" /etc/ssh/sshd_config
  else
    echo "AllowUsers $username" | sudo tee -a /etc/ssh/sshd_config >/dev/null
  fi
  echo "[ SSH ]: User added to allowed users"

  sudo systemctl restart sshd
  echo "[ SSH ]: Finished succesfully!"
}
