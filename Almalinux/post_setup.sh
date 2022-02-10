#!/bin/bash -x

# Remove docker key.json
if [[ -f /etc/docker/key.json ]]; then
  rm /etc/docker/key.json
fi

# Unique machine ID will be generated on first boot
echo "==> Removing machine ID"
truncate -s0 /etc/machine-id
rm -f /var/lib/dbus/machine-id

# remove efi nvram vars
rm -f /boot/efi/NvVars


echo "==> Cleaning up leftover dhcp leases"
if [ -d "/var/lib/dhcp" ]; then
    rm -f /var/lib/dhcp/*
fi

history -c
cat /dev/null > /root/.bash_history
unset HISTFILE

find /var/log -mtime -1 -type f -exec truncate -s 0 {} \;
rm -rf /var/log/*.gz /var/log/*.[0-9] /var/log/*-????????
rm -rf /var/lib/cloud/instances/*
rm -f /root/.ssh/authorized_keys /etc/ssh/*key*
touch /etc/ssh/revoked_keys
chmod 600 /etc/ssh/revoked_keys

# otherwise timers run immediately during first boot
rm -f /var/lib/systemd/timers/*

echo "==> Cleaning up tmp"
rm -rf /tmp/* /tmp/.* /var/tmp/* || true

# remove old logfiles
find /var/log -type f \( -regex '.*\.[0-9]+$' -or -regex '.*\.gz$' -or -regex '.*\.old$' -or -regex '.*\.xz$' \) -delete

# empty logfiles
find /var/log -type f -not -empty -exec tee {} < /dev/null \;


# # Zero out the free space to save space in the final image
# dd if=/dev/zero of=/EMPTY bs=1M
# rm -f /EMPTY

# Remove sudoers
sed -i -e 's/almalinux    ALL=(ALL) NOPASSWD: ALL//g' /etc/sudoers
rm -rf /home/almalinux
userdel -f almalinux

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quite too early
sync