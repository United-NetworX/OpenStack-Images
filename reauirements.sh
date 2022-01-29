#!/bin/bash

#
# Debian 11 Installer
#

echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" > /etc/apt/sources.list.d/ansible.list

apt-get update
apt-get install -y ansible
ansible-galaxy collection install devsec.hardening