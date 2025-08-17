#!/bin/bash

apt update -y && apt upgrade -y
apt install python3 python3-pip git speedtest-cli -y
apt install python3-pip
sudo apt-get install -y p7zip-full

wget https://raw.githubusercontent.com/SatanTech/bf/refs/heads/main/abe.zip
unzip -r abe.zip
pip3 install -r abe/requirements.zip

read -e -p "[*] Input your Bot Token : " bottoken
read -e -p "[*] Input Your Id Telegram :" admin
read -e -p "[*] Input QrCode Orkut :" qrcode

cat >/root/abe/var.txt <<EOF
BOT_TOKEN="$bottoken"
ADMIN="$admin"
qrCode="$qrcode"
EOF

cat > /etc/systemd/system/abe.service << EOF
[Unit]
Description=Python3 App Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 -m abe
WorkingDirectory=/root
Restart=on-failure
RestartSec=2
User=root
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

systemctl enable abe
systemctl start abe
systemctl restart abe
