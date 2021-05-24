#!/bin/bash

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m This script will install Orakuru node!\e[0m"
echo -e "\e[32m Do you want to proceed?\e[0m"
echo -n -e "\e[31m Please choose [Y|N]: \e[0m"
read input

if [[ $input == "N" || $input == "n" ]]; then
echo "exit"

else
echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m The installation of the software is in progress!\e[0m"
apt update -y > /dev/null 2>&1
apt upgrade -y > /dev/null 2>&1
apt install git gcc g++ pwgen -y > /dev/null 2>&1

userpass=$(pwgen 10 1)
useradd -m -p $userpass orakuru

usermod -aG sudo orakuru

ln -s /usr/local/go/bin/go /usr/local/bin/
export PATH=$PATH:/usr/local/go/bin; echo "export PATH=$PATH:/usr/local/go/bin" >> /home/orakuru/.profile


echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m Prepare Orakuru Node files!\e[0m"
mkdir /home/orakuru/.orakuru
wget https://raw.githubusercontent.com/orakurudata/crystal-ball/main/etc/web3.yml -O /home/orakuru/.orakuru/web3.yml > /dev/null 2>&1
wget https://raw.githubusercontent.com/orakurudata/crystal-ball/main/etc/requests.yml -O /home/orakuru/.orakuru/requests.yml > /dev/null 2>&1
cp -rp  /home/orakuru/.orakuru /home/orakuru/etc
chmod 600 /home/orakuru/.orakuru/web3.yml
chmod 600 /home/orakuru/etc/web3.yml
sed -i -e 's/https:\/\/bsc-dataseed.binance.org\//ws:\/\/localhost:8576/g' /home/orakuru/etc/web3.yml

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m Build Binary File!\e[0m"
chown -R orakuru:orakuru /home/orakuru
su orakuru -c "cd /home/orakuru; git clone https://github.com/orakurudata/crystal-ball > /dev/null 2>&1;cd crystal-ball;git checkout v0.2.1 > /dev/null 2>&1;go get ./... > /dev/null 2>&1;go install ./cmd/crystal-ball > /dev/null 2>&1"
ln -s /home/orakuru/go/bin/crystal-ball /usr/local/bin/
chown -h orakuru:orakuru /usr/local/bin/crystal-ball


echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m Please input your private key: \e[0m"
read key
sed -i -e s/key-here/$key/g /home/orakuru/etc/web3.yml
sed -i -e s/key-here/$key/g /home/orakuru/.orakuru/web3.yml
sed -i -e s/core-address-here/0x16a5Be448aFB23a80b1020A82739a527E0e99e54/g /home/orakuru/etc/web3.yml
sed -i -e s/core-address-here/0x16a5Be448aFB23a80b1020A82739a527E0e99e54/g /home/orakuru/.orakuru/web3.yml


printf "[Unit]
Description=Orakuru daemon
After=network-online.target

[Service]
User=orakuru
WorkingDirectory=/home/orakuru
ExecStart=/home/orakuru/go/bin/crystal-ball
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/orakuru.service

echo 'orakuru ALL=NOPASSWD: /bin/systemctl' >> /etc/sudoers

sudo systemctl daemon-reload
sudo systemctl enable orakuru.service
su orakuru -c "sudo systemctl restart orakuru.service"

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[31m Please save orakuru user password!!!\e[0m"
echo -e "\e[32m" $userpass "\e[0m"

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[31m To check the service status, please run\e[0m"
echo -e "\e[32m systemctl status orakuru.service \e[0m"

fi
