
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

variable "er_subnet1_name" {
  default = "on-prem-subnets1"
}

variable "er_subnet2_name" {
  default = "on-prem-subnets2"
}

variable "er_subnet1" {
  default = "172.150.0.0/24"
}

variable "er_subnet2" {
  default = "172.151.0.0/24"
}

variable "er_contract_cloud_to_onprem" {
  default = "cloud-to-onprem"
}