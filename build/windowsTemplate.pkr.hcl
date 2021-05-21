
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
  default = "Standard_DS1_v2"
}

source "azure-arm" "main" {
  subscription_id                   = "${var.az_subscription_id}"
  
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2019-Datacenter"
  os_type                           = "Windows"
  
  managed_image_name                = "WindowsServer2019-Packer"
  managed_image_resource_group_name = "NCloud_Images"
  
  location                          = "${var.azure_region}"
  vm_size                           = "${var.vm_size}"
  
  communicator                      = "winrm"
  winrm_insecure                    = true
  winrm_timeout                     = "5m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"
}

build {
  sources = ["source.azure-arm.main"]

  provisioner "powershell" {
    inline = [" # NOTE: the following *3* lines are only needed if the you have installed the Guest Agent.", "  while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "  #while ((Get-Service WindowsAzureTelemetryService).Status -ne 'Running') { Start-Sleep -s 5 }", "  while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm", "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"]
  }

}
