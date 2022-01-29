#!/bin/bash -x

# Package Cleanup
apt-get autoclean
apt-get autoremove -y

# Remove sudoers
sed -i -e 's/ubuntu    ALL=(ALL) NOPASSWD: ALL//g'
userdel ubuntu
rm -rf /home/ubuntu