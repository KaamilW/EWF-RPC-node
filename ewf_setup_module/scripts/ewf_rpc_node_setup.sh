#!/bin/bash

#Part #1 - setting up a new node
cd /
echo "Starting Bootstraping node..."  >> bootstrap-summary.txt
echo "Downloading script from GitHub..."  >> bootstrap-summary.txt
sudo wget -O install-rpc.bash https://raw.githubusercontent.com/energywebfoundation/ewf-rpc/master/${environment}-rpc/install-rpc-ubuntu-server-18.04-${environment}.bash
echo "Modyfing downloaded script..."  >> bootstrap-summary.txt
sudo sed -i '1 a export DEBIAN_FRONTEND=noninteractive' install-rpc.bash 2>> bootstrap-summary.txt
echo "Installing client..." >> bootstrap-summary.txt
sudo bash install-rpc.bash install-http 2>> bootstrap-summary.txt