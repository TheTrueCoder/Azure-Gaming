# Deprecation Notice
Azure stopped offering the free $100 a year student accounts to high school students, and they were removing GPU instances from that plan any way, so I would have to pay for the instances myself which is a sugnificant amount of money (around $0.60 USD per hour) not even including the exorbant overpriced egress bandwidth that you need to actually play games. I own a decent computer already, so this project was really just for the fun of messing with this tech. Because of this along with new interests, I'm not really going to keep working on this. If I work on it again though, this message will be removed.

That said, it should still work and you should be able to use it to make gaming VMs easier. Especially the build script.
You may need to change [the target VM type](https://github.com/TheTrueCoder/Azure-Gaming/blob/main/src/terraform/variables.tf#L33) but otherwise the rest of the instructions should work.

I'm also more than happy to help you get it working if you need help, just make an issue on this repository.

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
