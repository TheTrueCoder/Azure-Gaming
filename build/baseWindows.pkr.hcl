
variable "az_subscription_id" {
  type    = string
  default = "50248d07-cf32-4323-be00-c0db0e8eb9f0"
}

variable "azure_region" {
  type    = string
  default = "australiaeast"
}

variable "vm_size" {
  type    = string
  default = "Standard_F2"
}

variable "gpu_driver_url" {
  type = string
  default = "https://go.microsoft.com/fwlink/?linkid=874181"
}

variable "parsec_host_url" {
  type = string
}

source "azure-arm" "windows" {
  subscription_id                   = "${var.az_subscription_id}"
  
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2019-Datacenter-smalldisk"
  os_type                           = "Windows"

  managed_image_name                = "Base-Windows"
  managed_image_resource_group_name = "AUS_CloudGaming"
  
  location                          = "${var.azure_region}"
  vm_size                           = "${var.vm_size}"

  # os_disk_size_gb                   = 32
  
  communicator                      = "winrm"
  winrm_insecure                    = true
  winrm_timeout                     = "5m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"
}

build {
  sources = ["source.azure-arm.windows"]

  # Expand partition for expanded disks
  provisioner "powershell" {
    inline = ["$size = Get-PartitionSupportedSize -DriveLetter C", "Resize-Partition -DriveLetter C -Size $size.SizeMax"]
  }

  # Install Chocolatey
  provisioner "powershell" {
    inline = ["Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"]
  }

  # Install Chocolatey Packages
  provisioner "powershell" {
    inline = ["choco install -y 7zip firefox notepadplusplus vb-cable"]
  }

  # Install GRID driver
  provisioner "powershell" {
    environment_vars = ["DRIVERURL=${var.gpu_driver_url}"]
    script = "scripts/grid_driver.ps1"
  }

  # Install parsec script
  provisioner "powershell" {
    environment_vars = ["INSTALLLOC='C:\parsec'", "ZIPURL=${var.parsec_host_url}"]
    script = "scripts/parsec_setup.ps1"
  }

  # Sysprep
  provisioner "powershell" {
    inline = [" # NOTE: the following *3* lines are only needed if the you have installed the Guest Agent.", "  while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "  #while ((Get-Service WindowsAzureTelemetryService).Status -ne 'Running') { Start-Sleep -s 5 }", "  while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm", "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"]
  }

}
