
# CNC Credentials & Azure Subscription

variable "username" {}
variable "password" {}
variable "url" {}
variable "subscription_id" {}

# Hub VNet variables for L4-L7 Redirect

variable "services_ap" {
  default = "services-ap"
}

variable "fw_mgmt_epg" {
  default = "fw-mgmt-epg"
}

variable "fw_mgmt_contract" {
  default = "fw-mgmt-access"
}

variable "fw_mgmt_subnet_name" {
  default = "fw-mgmt-subnet"
}

variable "fw_mgmt_subnet" {
  default = "IP=='12.1.0.0/24'"
}

# 3rd party firewall

variable "fw_name" {
  default = "pan-fw"
}

# Network LB for firewall

variable "fw_nlb_name" {
  default = "fw-nlb"
}

variable "hub_services_cidr" {
  default = "12.1.0.0/21"
}