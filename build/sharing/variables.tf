variable "location" {
  type = string
  description = "Region to store managed images. This must be the same as the source VHD."
}

variable "imagename" {
  type = string
  description = "Name to give final managed image."
}

variable "imageuri" {
  type = string
  description = "Uri to VHD to make managed image from."
}

variable "size" {
  type = number
  description = "Size of image in GB."
}

variable "imageos" {
  type = string
  description = "OS of source image. Default Windows. Valid inputs: [Linux, Windows]"
  default = "Windows"
}

variable "appname" {
  type = string
  default = "Azure-Gaming"
}

variable "projecturl" {
  type = string
  default = "https://github.com/TheTrueCoder/Azure-Gaming"
}