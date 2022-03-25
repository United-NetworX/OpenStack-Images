# OpenStack-Images
This Repository contains a bunch of Cloud Images designed to run in the Meros OpenStack Cloud enviroment.

![](etc/Logo_Meros_side.png)

|[![Packer AlmaLinux 8.5](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/almalinux-8.5.yml/badge.svg)](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/almalinux-8.5.yml)|[![Packer Debian 10](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/debian-10.yml/badge.svg)](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/debian-10.yml)|[![Packer Ubuntu 18.04](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/ubuntu-18.04.yml/badge.svg)](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/ubuntu-18.04.yml)|
|--|--|--|
|[![Packer FreeBSD 13](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/freebsd-13.yml/badge.svg)](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/freebsd-13.yml)|[![Packer Debian 11](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/debian-11.yml/badge.svg)](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/debian-11.yml)|[![Packer Ubuntu 20.04](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/ubuntu-20.04.yml/badge.svg)](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/ubuntu-20.04.yml)|
|||[![Packer Ubuntu 22.04](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/ubuntu-22.04.yml/badge.svg)](https://github.com/United-NetworX/OpenStack-Images/actions/workflows/ubuntu-22.04.yml)

## Supportet Operating Systems
### Ubuntu
+ 18.04 LTS
+ 20.04 LTS
+ 22.04 LTS

### Debian
+ 10
+ 11

### AlmaLinux
+ 8.5

### FreeBSD
+ 13

### Windows (next up)
+ W2k22

## Image Preperation
The Default login for all Linux and FreeBSD based Images are:

 `root`:`mer0s`

All Linux based Images are hardened with the following baseline.

https://github.com/dev-sec/linux-baseline

### Regenerate CloudInit Image

```bash
cloud-localds cloud-init.img cloud-init.yml
```
