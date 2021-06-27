terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.appname}-Images"
  location = var.location
}

resource "azurerm_image" "img" {
  name                = var.imagename
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  os_disk {
    os_type  = var.imageos
    os_state = "Generalized"
    blob_uri = var.imageuri
    size_gb  = var.size
  }
}