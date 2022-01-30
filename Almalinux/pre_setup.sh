#!/bin/bash -x

# Generate SSH Keys
rm /etc/ssh/ssh_host_*
systemctl restart sshd

# Allow Root Login
sed -i -e '/^#PermitRootLogin/s/^.*$/PermitRootLogin yes/' /etc/ssh/sshd_config

# Package Update / Installation
yum update -y
yum install -y \
  ca-certificates curl htop iftop nano qemu-guest-agent
 
 systemctl enable qemu-guest-agent

echo "almalinux    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
