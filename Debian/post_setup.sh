#!/bin/bash -x

# Package Cleanup
apt-get autoclean
apt-get autoremove -y

# Remove sudoers
sed -i -e 's/debian    ALL=(ALL) NOPASSWD: ALL//g' /etc/sudoers
rm -rf /home/debian
userdel -f debian