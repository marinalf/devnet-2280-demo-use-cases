# Define the provider source

terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = ">= 2.10.1"
    }
  }
  required_version = ">= 1.2"
}

# Provider Config

provider "aci" {
  username = var.username
  password = var.password
  url      = var.url
  insecure = true

}
