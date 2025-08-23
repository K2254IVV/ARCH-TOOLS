#!/bin/sh
clear
echo "Installing ArchTools PiM!"
mkdir -p /tmp/archtools-tmp
cd /tmp/archtools-tmp
switcherurl=$(wget -q -O - https://raw.githubusercontent.com/K2254IVV/ARCH-TOOLS/refs/heads/main/tools/switcher/lastest-pim | tr -d '\n')
wget $switcherurl
debiurl=$(wget -q -O - https://raw.githubusercontent.com/K2254IVV/ARCH-TOOLS/refs/heads/main/tools/deb-installer/lastest | tr -d '\n')
wget $debiurl
sudo chmod +x switcher
sudo chmod +x deb-install
echo "Installing Scripts to /bin..."
sudo cp -Ri ./* /bin
echo "ArchTools PiM Installed!"
echo "Deleting TEMP files..."
sudo rm -rf /tmp/archtools-tmp
cd ~
