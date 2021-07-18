variable "admin_username" {
  type        = string
  description = "Administrator user name for virtual machine"
}

variable "admin_password" {
  type        = string
  description = "Password must meet Azure complexity requirements"
  sensitive   = true
}

variable "instance_type" {
  type        = string
  description = "Choose type of instance. Valid inputs: [setup, gpu, gpu-promo]"
}

variable "parsec_sessionid" {
  type = string
  description = "Session ID obtained from Parsec API."
}

variable "image_id" {
  type = string
}

variable "location" {
  type = string
}

variable "subdomain" {
  type    = string
  default = "azuregaming"
}

variable "sizes" {
  default = {
    setup     = "Standard_B4ms"
    gpu       = "Standard_NV6"
    gpu-promo = "Standard_NV6_Promo"
  }
}

variable "appname" {
  type    = string
  default = "Azure-Gaming"
}

variable "projecturl" {
  type    = string
  default = "https://github.com/TheTrueCoder/Azure-Gaming"
}
