
variable "autounattend" {
  type    = string
  default = "./scripts/unattended_2022.xml"
}

variable "disk_size" {
  type    = string
  default = "61440"
}

variable "disk_type_id" {
  type    = string
  default = "1"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "hyperv_switchname" {
  type    = string
  default = "${env("hyperv_switchname")}"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:4f1457c4fe14ce48c9b2324924f33ca4f0470475e6da851b39ccbf98f44e7852"
}

variable "iso_url" {
  type    = string
  default = "https://software-download.microsoft.com/download/sg/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
}

variable "manually_download_iso_from" {
  type    = string
  default = "https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022"
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "restart_timeout" {
  type    = string
  default = "5m"
}

variable "virtio_win_iso" {
  type    = string
  default = "~/virtio-win.iso"
}

variable "vmx_version" {
  type    = string
  default = "14"
}

variable "winrm_timeout" {
  type    = string
  default = "2h"
}

source "hyperv-iso" "W2k22-HyperV" {
  boot_wait                        = "0s"
  communicator                     = "winrm"
  configuration_version            = "8.0"
  cpus                             = 2
  disk_size                        = "${var.disk_size}"
  enable_secure_boot               = true
  enable_virtualization_extensions = true
  floppy_files                     = ["${var.autounattend}", "./scripts/disable-screensaver.ps1", "./scripts/disable-winrm.ps1", "./scripts/enable-winrm.ps1", "./scripts/microsoft-updates.bat", "./scripts/unattend.xml", "./scripts/sysprep.bat", "./scripts/win-updates.ps1"]
  guest_additions_mode             = "disable"
  iso_checksum                     = "${var.iso_checksum}"
  iso_url                          = "${var.iso_url}"
  memory                           = "${var.memory}"
  shutdown_command                 = "a:/sysprep.bat"
  switch_name                      = "${var.hyperv_switchname}"
  vm_name                          = "WindowsServer2022"
  winrm_password                   = "mer0s"
  winrm_timeout                    = "${var.winrm_timeout}"
  winrm_username                   = "Admin"
}

source "qemu" "W2k22-QEMU" {
  accelerator      = "tcg"
  boot_wait        = "0s"
  communicator     = "winrm"
  cpus             = 2
  disk_size        = "${var.disk_size}"
  floppy_files     = ["${var.autounattend}", "./scripts/disable-screensaver.ps1", "./scripts/disable-winrm.ps1", "./scripts/enable-winrm.ps1", "./scripts/microsoft-updates.bat", "./scripts/unattend.xml", "./scripts/sysprep.bat", "./scripts/win-updates.ps1"]
  headless         = true
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  memory           = "${var.memory}"
  output_directory = "windows_2022-qemu"
  qemuargs         = [["-drive", "file=windows_2022-qemu/{{ .Name }},if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1"], ["-drive", "file=${var.iso_url},media=cdrom,index=2"], ["-drive", "file=${var.virtio_win_iso},media=cdrom,index=3"]]
  shutdown_command = "a:/sysprep.bat"
  vm_name          = "WindowsServer2022"
  winrm_password   = "mer0s"
  winrm_timeout    = "${var.winrm_timeout}"
  winrm_username   = "Admin"
}

source "virtualbox-iso" "W2k22-VirtaulBox" {
  boot_wait            = "2m"
  communicator         = "winrm"
  cpus                 = 2
  disk_size            = "${var.disk_size}"
  floppy_files         = ["${var.autounattend}", "./scripts/disable-screensaver.ps1", "./scripts/disable-winrm.ps1", "./scripts/enable-winrm.ps1", "./scripts/microsoft-updates.bat", "./scripts/win-updates.ps1", "./scripts/unattend.xml", "./scripts/sysprep.bat"]
  guest_additions_mode = "disable"
  guest_os_type        = "Windows2016_64"
  headless             = "${var.headless}"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = "${var.memory}"
  shutdown_command     = "a:/sysprep.bat"
  vm_name              = "WindowsServer2022"
  winrm_password       = "mer0s"
  winrm_timeout        = "${var.winrm_timeout}"
  winrm_username       = "Admin"
}

source "vmware-iso" "W2k22-VMware" {
  boot_wait         = "2m"
  communicator      = "winrm"
  cpus              = 2
  disk_adapter_type = "lsisas1068"
  disk_size         = "${var.disk_size}"
  disk_type_id      = "${var.disk_type_id}"
  floppy_files      = ["${var.autounattend}", "./scripts/disable-screensaver.ps1", "./scripts/disable-winrm.ps1", "./scripts/enable-winrm.ps1", "./scripts/microsoft-updates.bat", "./scripts/unattend.xml", "./scripts/sysprep.bat", "./scripts/win-updates.ps1"]
  guest_os_type     = "windows9srv-64"
  headless          = "${var.headless}"
  iso_checksum      = "${var.iso_checksum}"
  iso_url           = "${var.iso_url}"
  memory            = "${var.memory}"
  shutdown_command  = "a:/sysprep.bat"
  version           = "${var.vmx_version}"
  vm_name           = "WindowsServer2022"
  vmx_data = {
    "RemoteDisplay.vnc.enabled" = "false"
    "RemoteDisplay.vnc.port"    = "5900"
  }
  vmx_remove_ethernet_interfaces = true
  vnc_port_max                   = 5980
  vnc_port_min                   = 5900
  winrm_password                 = "mer0s"
  winrm_timeout                  = "${var.winrm_timeout}"
  winrm_username                 = "Admin"
}

build {
  sources = ["source.hyperv-iso", "source.qemu", "source.virtualbox-iso", "source.vmware-iso"]

  provisioner "windows-shell" {
    execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
    scripts         = ["./scripts/enable-rdp.bat"]
  }

  provisioner "powershell" {
    scripts = ["./scripts/vm-guest-tools.ps1", "./scripts/debloat-windows.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "${var.restart_timeout}"
  }

  provisioner "windows-shell" {
    execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
    scripts         = ["./scripts/pin-powershell.bat", "./scripts/set-winrm-automatic.bat", "./scripts/uac-enable.bat", "./scripts/compile-dotnet-assemblies.bat", "./scripts/compact.bat"]
  }

  post-processor "vagrant" {
    keep_input_artifact  = false
    output               = "windows_2022_<no value>.box"
    vagrantfile_template = "vagrantfile-windows_2016.template"
  }
}
