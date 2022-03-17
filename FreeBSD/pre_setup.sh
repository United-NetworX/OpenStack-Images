#!/bin/csh

# Generate SSH Keys
#rm /etc/ssh/ssh_host_*
#service sshd restart

# Package Update / Installation
pkg update && pkg upgrade -y
pkg install -y \
  curl htop iftop nano qemu-guest-agent

echo "" >> /etc/rc.conf
echo "# Enable Qemu Guest Agent" >> /etc/rc.conf
echo 'qemu_guest_agent_enable="YES"' >> /etc/rc.conf
echo 'qemu_guest_agent_flags="-d -v -l /var/log/qemu-ga.log"' >> /etc/rc.conf

service qemu-guest-agent start
