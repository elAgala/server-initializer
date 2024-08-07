#!/bin/bash

# Check for required arguments
if [ $# -ne 3 ]; then
  echo "Usage: $0 <username> <server_ip> <port>"
  exit 1
fi

# Extract arguments
username="$1"
server_ip="$2"
port="$3"

# Script path
script_path="index.sh"

# Transfer the script to the server
scp -P $port "$script_path" "$username@$server_ip:/tmp/" || {
  echo "Error transferring script"
  exit 1
}

# Execute the script on the server
ssh -P $port "$username@$server_ip" "bash /tmp/"$script_path"" || {
  echo "Error executing script on server"
  exit 1
}

echo "Script execution completed on $username@$server_ip"
