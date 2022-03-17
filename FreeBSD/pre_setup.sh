#!/bin/bash -x

# Generate SSH Keys
#rm /etc/ssh/ssh_host_*
#service sshd restart

# Package Update / Installation
pkg update && pkg upgrade -y
pkg install -y \
  ca-certificates curl htop iftop nano qemu-guest-agent
 
service start qemu-guest-agent
