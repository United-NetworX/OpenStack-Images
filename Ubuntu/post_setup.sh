#!/bin/bash -x

# Package Cleanup
apt-get autoclean
apt-get autoremove -y

# Remove ubuntu user
sed -i -e 's/ubuntu ALL=(ALL) NOPASSWD: ALL//g' /etc/sudoers
rm -rf /home/ubuntu
passwd -d ubuntu
usermod -s /usr/sbin/nologin ubuntu
usermod -L ubuntu
userdel -f ubuntu