#!/bin/sh

set -ex

if [ `id -u` -ne 0 ]; then
     sudo $0
    exit 0
fi

## your custom code below
apt-get -y install htop nano iftop


rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server

sed -i -e '/^#PermitRootLogin/s/^.*$/PermitRootLogin yes/' /etc/ssh/sshd_config