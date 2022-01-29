#!/bin/bash -x

# Package Cleanup
apt-get autoclean
apt-get autoremove -y

# Remove sudoers
sed -i -e 's/debian    ALL=(ALL) NOPASSWD: ALL//g' /etc/sudoers
userdel -f ubuntu
rm -rf /home/ubuntu