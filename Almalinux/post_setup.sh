#!/bin/bash -x

# Remove sudoers
sed -i -e 's/almalinux    ALL=(ALL) NOPASSWD: ALL//g' /etc/sudoers
rm -rf /home/almalinux
userdel -f almalinux