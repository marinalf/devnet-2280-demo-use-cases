
# CNC Credentials & Azure Subscription

variable "username" {}
variable "password" {}
variable "url" {}
variable "subscription_id" {}

variable "services_vrf" {
  default = "hub-services"
}

# Firewall/LB CIDR/Subnets

variable "fw_cidr" {
  default = "12.1.0.0/21"
}

variable "fw_subnets" {
  type = map(object({
    name = string
    ip   = string
  }))
  default = {
    mgmt-subnet = {
      name = "fw-mgmt-subnet"
      ip   = "12.1.0.0/24"
    },
    trust-subnet = {
      name = "fw-trust-subnet"
      ip   = "12.1.1.0/24"
    },
    untrust-subnet = {
      name = "fw-untrust-subnet"
      ip   = "12.1.2.0/24"
    },
    lb-subnet = {
      name = "lb-subnet"
      ip   = "12.1.3.0/24"
    }
  }
}

variable "hub_region" {
  default = "uksouth"
}