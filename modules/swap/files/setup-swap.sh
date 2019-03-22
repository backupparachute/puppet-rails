#!/bin/bash

sudo swapon -s

sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024k
sudo mkswap /swapfile
sudo swapon /swapfile

echo "/swapfile       none    swap    sw      0       0" | sudo tee -a /etc/fstab

echo 30 | sudo tee /proc/sys/vm/swappiness
echo vm.swappiness = 30 | sudo tee -a /etc/sysctl.conf

sudo chown root:root /swapfile
sudo chmod 0600 /swapfile
