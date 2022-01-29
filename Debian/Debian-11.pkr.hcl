
variable "cloud_init_image" {
  type    = string
  default = "Debian/cloud-init.img"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "disk_size" {
  type    = string
  default = "8192"
}

variable "image_checksum" {
  type    = string
  default = "44e1dfcb821cec45ba290c5a88d03c23e453b51c634e0b6f09318aac15f620f28fc2b0d5c0576a35c8fee7a91246530cff0a9a9b789c03b4244c6e653220f9f0"
}

variable "image_checksum_type" {
  type    = string
  default = "sha512"
}

variable "image_url" {
  type    = string
  default = "https://cdimage.debian.org/cdimage/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
}

variable "memory" {
  type    = string
  default = "2048M"
}

variable "ssh_password" {
  type    = string
  default = "mer0s"
}

variable "ssh_username" {
  type    = string
  default = "debian"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

locals {
  vm_name = "debian-11-${local.timestamp}.qcow2"
}

source "qemu" "debian" {
  accelerator         = "tcg"
  boot_command        = ["<enter>"]
  disk_compression    = true
  disk_image          = true
  disk_size           = "${var.disk_size}"
  format              = "qcow2"
  headless            = true
  iso_checksum        = "${var.image_checksum}"
  iso_url             = "${var.image_url}"
  output_directory    = "build"
  qemuargs            = [["-m", "${var.memory}"], ["-smp", "cpus=${var.cpus}"], ["-cdrom", "${var.cloud_init_image}"], ["-serial", "mon:stdio"]]
  ssh_password        = "${var.ssh_password}"
  ssh_port            = 22
  ssh_username        = "${var.ssh_username}"
  ssh_wait_timeout    = "300s"
  use_default_display = false
  vm_name             = "${local.vm_name}"
}

build {
  sources = ["source.qemu.debian"]

  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash -x '{{ .Path }}'"
    scripts         = ["Debian/pre_setup.sh"]
  }

  provisioner "shell" {
    inline = ["sudo sync"]
  }

  provisioner "ansible" {
    playbook_file = "./os-hardening.yml"
    command = "/usr/bin/ansible-playbook"
    ansible_env_vars = ["ANSIBLE_NOCOLOR=True"]
    extra_arguments = ["--become"]
    user = "${var.ssh_username}"
  }

  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash -x '{{ .Path }}'"
    scripts         = ["Debian/post_setup.sh"]
  }
}
