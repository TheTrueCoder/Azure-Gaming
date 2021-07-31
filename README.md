# Azure-Gaming
A program to automate Gaming on azure Virtual Machines

# DISCLAIMER
Currently, the images needed to use these scripts must be shared to you or built from the packer templates. I haven't yet written a guide on building images but it involves the packer templates in the build folder.
If you don't know where you are getting an image, this configuration won't work currently. I will try to make this easier this soon.

# How to use
## Azure Cloud Shell
- Start a Powershell Az cloud shell.
- Clone this repo with `git clone https://github.com/TheTrueCoder/Azure-Gaming.git`.
- Change directory to config `cd Azure-Gaming/src/terraform`.
- Copy the terraform.tfvars.template to the name terraform.tfvars `cp terraform.tfvars.template terraform.tfvars`.
- Edit terraform.tfvars to include your image resource id and region `code terraform.tfvars`.
- Run `terraform init` to initialise terraform (Install providers, etc...).
- Launch vm with `terraform apply`. Respond setup to instance_type to get cheap cpu-only VM.
- Connect to VM with RDP using the outputted public_fqdn and your selected user and password.
- Login to Parsec.
- Run `terraform apply` but choose gpu or gpu-promo instead.
- Connect back over RDP and open Parsec, then disconnect.
- Connect with Parsec and enjoy you GPU desktop!

### Destroy resources afterwards
- If the cloud shell shuts down, reopen the shell and cd back to the terraform folder. `cd Azure-Gaming/src/terraform`
- Run the command `terraform destroy` and type responses to the questions given.
- (Optional) If you want to be sure it's gone, after the previous step completes, goto the [Azure resource group page](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups) and make sure there is no resource group called "Azure-Gaming".