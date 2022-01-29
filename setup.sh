#!/bin/bash -x

# Generate SSH Keys
rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server

# Allow Root Login
#sed -i -e '/^#PermitRootLogin/s/^.*$/PermitRootLogin yes/' /etc/ssh/sshd_config

# Package Update / Installation
apt-get update && apt-get upgrade -y
apt-get install -y \
  apt-transport-https ca-certificates curl software-properties-common htop iftop nano

apt-get autoclean

apt-get autoremove -y

echo "ubuntu    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers