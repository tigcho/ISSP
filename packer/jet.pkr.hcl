variable "cpus" {}
variable "memory" {}
variable "disk_size" {}
variable "winrm_username" {}
variable "winrm_password" {}
variable "vm_name" {}
variable "headless" {}
variable "output_directory" {}
variable "static_ip" {}
variable "gateway" {}
variable "netmask" {}
variable "dns" {}

source "virtualbox-iso" "jet" {
  floppy_files         = [
    "scripts/autounattend.xml",
    "scripts/setup.ps1",
    "scripts/win-update.ps1",
    "scripts/cleanup.ps1",
    "scripts/network-config.ps1"
  ]
  guest_os_type        = "Windows2025_64"
  iso_url              = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
  iso_checksum         = "sha256:d0ef4502e350e3c6c53c15b1b3020d38a5ded011bf04998e950720ac8579b23d"
  communicator         = "winrm"
  guest_additions_mode = "disable"
  winrm_username       = var.winrm_username
  winrm_password       = var.winrm_password
  winrm_port           = 5985
  winrm_use_ssl        = false
  winrm_insecure       = true
  winrm_timeout        = "4h"
  vm_name              = var.vm_name
  cpus                 = var.cpus
  memory               = var.memory
  disk_size            = var.disk_size
  headless             = var.headless
  output_directory     = var.output_directory
  shutdown_command     = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nic2", "hostonly"],
    ["modifyvm", "{{.Name}}", "--hostonlyadapter2", "VirtualBox Host-Only Ethernet Adapter"],
    ["modifyvm", "{{.Name}}", "--pae", "on"],
    ["modifyvm", "{{.Name}}", "--nestedpaging", "on"],
    ["modifyvm", "{{.Name}}", "--hwvirtex", "on"],
    ["modifyvm", "{{.Name}}", "--vram", "16"]
  ]
}

build {
  sources = ["source.virtualbox-iso.jet"]
  
  provisioner "powershell" {
    script = "scripts/network-config.ps1"
    pause_before = "30s"
  }

  provisioner "powershell" {
    script = "scripts/win-update.ps1"
    pause_before = "30s"
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
  }

  provisioner "powershell" {
    script = "scripts/win-update.ps1"
    pause_before = "30s"
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
  }

  provisioner "powershell" {
    script = "scripts/cleanup.ps1"
    pause_before = "30s"
  }
}
