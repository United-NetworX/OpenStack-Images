
variable "cloud_init_image" {
  type    = string
  default = "FreeBSD/cloud-init.img"
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
  default = "3C7C7FAFE5C389B9295DCAAB7A71C47CC30AD6E79E3A0C9CB164933AD2FB9814"
}

variable "image_checksum_type" {
  type    = string
  default = "sha512"
}

variable "image_url" {
  type    = string
  default = "https://object-storage.public.mtl1.vexxhost.net/swift/v1/1dbafeefbd4f4c80864414a441e72dd2/bsd-cloud-image.org/images/freebsd/12.2/freebsd-12.2.qcow2"
}

variable "memory" {
  type    = string
  default = "2048M"
}

variable "ssh_password" {
  type    = string
  default = "!234AaAa56"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

locals {
  vm_name = "freebsd-12-${local.timestamp}.qcow2"
}

source "qemu" "freebsd" {
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
  sources = ["source.qemu.freebsd"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; env {{ .Vars }} {{ .Path }}"
    scripts         = ["FreeBSD/pre_setup.sh"]
  }

  provisioner "ansible" {
    playbook_file = "./FreeBSD/config_playbook.yml"
    ansible_env_vars = ["ANSIBLE_NOCOLOR=True"]
    extra_arguments = ["--become"]
    user = "${var.ssh_username}"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; env {{ .Vars }} {{ .Path }}"
    scripts         = ["FreeBSD/post_setup.sh"]
  }
}
