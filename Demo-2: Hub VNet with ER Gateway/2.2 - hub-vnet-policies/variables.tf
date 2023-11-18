
# CNC Credentials & Azure Subscription

variable "username" {}
variable "password" {}
variable "url" {}
variable "subscription_id" {}

# Hub VNet variables for Express Route

variable "tenant_name" {
  default = "devnet"
}

variable "services_ap" {
  default = "services-ap"
}

variable "er_epg" {
  default = "er-gateway-epg"
}

variable "onprem_subnets" {
  type = map(object({
    name = string
    subnet = string
  }))
  default = {
    subnet1 = {
      name = "on-prem-subnets1"
      subnet   = "172.150.0.0/24"
    },
    subnet2 = {
      name = "on-prem-subnets2"
      subnet   = "172.151.0.0/24"
    }
  }
}

variable "er_contract_cloud_to_onprem" {
  default = "cloud-to-onprem"
}