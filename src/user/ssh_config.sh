#!/bin/bash

function config_ssh() {
  username=$1

  echo "[ SSH ]: Starting setup"
  ssh_dir="/home/$username/.ssh"

  sudo mkdir -p $ssh_dir
  sudo chmod 700 $ssh_dir

  sudo touch "$ssh_dir/authorized_keys"
  sudo chmod 600 "$ssh_dir/authorized_keys"
  sudo chown -R "$username:$username" $ssh_dir
  echo "[ SSH ]: Created ~/.ssh/authorized_keys"

  echo "[ SSH ]: Paste the public key for $username (leave empty to skip)"
  read -r public_key
  if [ -n "$public_key" ]; then
    echo "$public_key" | sudo tee -a "$ssh_dir/authorized_keys" >/dev/null
    echo "[ SSH ]: Public key added to $ssh_dir/authorized_keys."
  else
    echo "[ SSH ]: No public key provided, skipping..."
  fi

  # Create SSH configuration file instead of modifying main sshd_config
  config_file="/etc/ssh/sshd_config.d/server-initializer.conf"

  echo "[ SSH ]: Configuring SSH settings"
  sudo mkdir -p /etc/ssh/sshd_config.d

  # Check if config file exists
  if [ ! -f "$config_file" ]; then
    # Create the configuration file with security settings
    sudo tee "$config_file" >/dev/null <<EOF
# Server Initializer SSH Configuration
# This file is managed by @elAgala/server-initializer

# Disable root login
PermitRootLogin no

# Disable password authentication
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no

# Only allow specific users
AllowUsers $username
EOF
    echo "[ SSH ]: SSH configuration file created at $config_file"
  else
    # File exists, check if user is already in AllowUsers
    if ! sudo grep -q "AllowUsers.*$username" "$config_file"; then
      # Add user to existing AllowUsers line
      sudo sed -i "s/^AllowUsers.*/& $username/" "$config_file"
      echo "[ SSH ]: User $username added to existing AllowUsers"
    else
      echo "[ SSH ]: User $username already in AllowUsers"
    fi
  fi

  echo "[ SSH ]: Root login disabled"
  echo "[ SSH ]: Password authentication disabled"
  echo "[ SSH ]: User $username added to allowed users"

  sudo systemctl restart sshd
  echo "[ SSH ]: Finished succesfully!"
}