
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.appname
  location = var.location
  tags = {
    App        = var.appname
    ProjectURL = var.projecturl
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.appname}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.appname}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IP
resource "random_integer" "pubip" {
  min = 1000
  max = 9999
}

resource "azurerm_public_ip" "publicip" {
  name                = "${var.appname}-publicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "${var.subdomain} ${~random_integer.pubip.id}"
}

# Create Network Security Group and rule
# I'll revisit this soon to get a firewall configured on the vm
# resource "azurerm_network_security_group" "nsg" {
#   name                = "${var.appname}-NSG"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "SSH"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.appname}-NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.appname}-NICConfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Create a Windows virtual machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "${var.appname}-VM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = lookup(var.sizes, var.instance_type)
  admin_username        = var.admin_username
  admin_password        = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.image_id
}

data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.publicip.name
  resource_group_name = azurerm_resource_group.rg.name
  # depends_on          = [azurerm_windows_virtual_machine.vm]
}

output "public_ip_address" {
  value = data.azurerm_public_ip.ip.ip_address
}

output "public_fqdn" {
  value = data.azurerm_public_ip.ip.fqdn
}