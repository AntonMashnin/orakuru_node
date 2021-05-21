# orakuru_node
This repository contains information about the installation process of the Orakuru Node

## Requirements
There are no special requirements. The bash script will install all necessary software and perform all configuration automatically

You just need to install 'wget' tool to make possibility run and install it:
```
sudo apt install wget -y
```

## Features
- TestNet-Node

## Notes
- Please note: This script will install the Orakuru node with all necessary components and run it on behalf of "orakuru" user.
- home directory: /home/orakuru
  - etc directory cointains configuration files:
    - requests.yml
    - web3.yml
  - go/bin cointains binary file:
    - crystal-ball

## Installation
To configure and install BSC Node please run:
```
sudo wget https://raw.githubusercontent.com/AntonMashnin/install_bsc_node/main/bscinstall.sh
sudo chmod +x bscinstall.sh
sudo ./bscinstall.sh
```
