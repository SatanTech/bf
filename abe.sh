#!/bin/bash

apt update -y && apt upgrade -y
apt install python3 python3-pip git speedtest-cli -y
apt install python3-pip
sudo apt-get install -y p7zip-full

rm -rf abe.zip
wget https://raw.githubusercontent.com/SatanTech/bf/refs/heads/main/abe.zip
unzip abe.zip
#pip3 install -r abe/requirements.txt

VERSION=$(grep "VERSION_ID" /etc/os-release | cut -d'"' -f2)
OS=$(grep "^ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"')

# Fungsi untuk menginstal di Debian 11 atau lebih rendah dan Ubuntu 18.04, 20.04
install_debian11_ubuntu20_down() {
    echo "Deteksi $OS versi $VERSION atau lebih rendah..."
    pip3 install -r abe/requirements.txt
}

install_debian12_ubuntu22_up() {
    echo "Deteksi $OS versi $VERSION atau lebih tinggi..."
    pip3 install -r abe/requirements.txt --break-system-packages
}

if [[ "$OS" == "debian" ]]; then
    if (( $(echo "$VERSION < 12" | bc -l) )); then
        install_debian11_ubuntu20_down
    else
        install_debian12_ubuntu22_up
    fi
elif [[ "$OS" == "ubuntu" ]]; then
    if (( $(echo "$VERSION < 22.04" | bc -l) )); then
        install_debian11_ubuntu20_down
    else
        install_debian12_ubuntu22_up
    fi
else
    echo "Distribusi tidak dikenali. Hanya mendukung Debian dan Ubuntu."
fi

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
rm -rf abe.zip
