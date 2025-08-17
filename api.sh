#!/bin/bash

apt update -y && apt upgrade -y
apt install python3 python3-pip git speedtest-cli -y
apt install python3-pip
sudo apt-get install -y p7zip-full

wget -qO- /usr/bin "https://raw.githubusercontent.com/SatanTech/bf/refs/heads/main/api.py" && chmod +x /usr/bin/*

cat > /etc/systemd/system/api.service << EOF
[Unit]
Description=Api Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 api.py
WorkingDirectory=/usr/bin
Restart=on-failure
RestartSec=2
User=root
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

systemctl enable api
systemctl start api
systemctl restart api