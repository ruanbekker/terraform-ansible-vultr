variable "ubuntu_20" {
  type    = string
  default = "Ubuntu 20.04 LTS x64"
}

variable "debian_10" {
  type    = string
  default = "Debian 10 x64 (buster)"
}

variable "ssh_key_name" {
  type    = string
  default = "vultr"
}

variable "instance_name" {
  type    = string
  default = "eph-instance"
}

variable "ansible_user" {
  type    = string
  default = "root"
}

variable "os_user" {
  type    = string
  default = "snake"
}

variable "vultr_api_key" {
  type    = string
}
