#!/bin/bash

echo "Installing and setting up nginx"
./install_nginx.sh
echo "Installing and setting up Docker"
./install_docker.sh
echo "New user creation"
./create_user.sh
