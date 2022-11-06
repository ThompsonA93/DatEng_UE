#!/bin/bash
# Script to install MongoDB
sudo apt install -y mongodb
printf "\nMongoDB: \n$(mongod --version)\n"
printf "\nService: \n$(systemctl status mongodb)\n"