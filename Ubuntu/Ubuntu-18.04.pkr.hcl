
variable "cloud_init_image" {
  type    = string
  default = "cloud-init.img"
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
  default = "00360c1fe70be94f38d95a999fa755026586df25f946762d68aa5f7013b5b719"
}

variable "image_checksum_type" {
  type    = string
  default = "sha256"
}

variable "image_url" {
  type    = string
  default = "https://cloud-images.ubuntu.com/minimal/releases/bionic/release/ubuntu-18.04-minimal-cloudimg-amd64.img"
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
  default = "ubuntu"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

locals {
  vm_name = "ubuntu-18.04-${local.timestamp}.qcow2"
}

source "qemu" "ubuntu" {
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
  sources = ["source.qemu.ubuntu"]

  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash -x '{{ .Path }}'"
    scripts         = ["pre_setup.sh"]
  }

  provisioner "shell" {
    inline = ["sudo sync"]
  }

  provisioner "ansible" {
    playbook_file = "../os-hardening.yml"
    ansible_env_vars = ["ANSIBLE_NOCOLOR=True"]
    extra_arguments = ["--become"]
    user = "${var.ssh_username}"
  }

  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash -x '{{ .Path }}'"
    scripts         = ["post_setup.sh"]
  }

  provisioner "shell" {
    inline = ["sudo sync"]
  }

}