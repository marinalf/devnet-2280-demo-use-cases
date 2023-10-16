
# CNC Credentials & Azure Subscription

variable "username" {}
variable "password" {}
variable "url" {}
variable "subscription_id" {}

variable "tenant_name" {
  default = "devnet"
}

variable "vnet1_name" {
  default = "vnet-1"
}

variable "vnet2_name" {
  default = "vnet-2"
}

# VNet1 EPG

variable "vnet1_ap" {
  default = "vnet1-ap"
}

variable "vnet1_epg" {
  default = "vnet1-epg"
}

variable "vnet1_subnets_selectors" {
  type = map(object({
    name = string
    expression   = string
  }))
  default = {
    selector_subnet1 = {
      name = "selector_subnet1"
      expression   = "IP=='10.100.1.0/24'"
    },
    selector_subnet2 = {
      name = "selector_subnet2"
      expression   = "IP=='10.100.2.0/24'"
    }
  }
}

# Internet External EPG + Contract

variable "vnet1_internet" {
  default = "vnet1-internet"
}

variable "vnet1_selector_name" {
  default = "Internet"
}

variable "vnet1_selector_subnet" {
  default = "0.0.0.0/0"
}

variable "internet_contract" {
  default = "internet-access" 
}

# VNet2 EPG (Single ASG, Network Centric)

variable "vnet2_ap" {
  default = "vnet2-ap"
}

variable "vnet2_epg" {
  default = "vnet2-epg"
}

variable "vnet2_subnets_selectors" {
  type = map(object({
    name = string
    expression   = string
  }))
  default = {
    selector_subnet1 = {
      name = "selector_subnet1"
      expression   = "IP=='20.100.1.0/24'"
    },
    selector_subnet2 = {
      name = "selector_subnet2"
      expression   = "IP=='20.100.2.0/24'"
    }
  }
}

# Inter-VNet Contract

variable "inter_vnet_contract" {
  default = "inter-vnet-contract"
}

# ER contract to allow on-prem/cloud and cloud/on-prem connectivity

variable "er_contract_onprem_to_cloud" {
  default = "onprem-to-cloud"
}

variable "er_contract_cloud_to_onprem" {
  default = "cloud-to-onprem"
}


