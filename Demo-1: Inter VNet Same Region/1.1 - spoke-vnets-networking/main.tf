
# Tenant and Cloud Account mapping

resource "aci_tenant" "tenant1" {
  name        = var.tenant_name
  description = "This tenant has been created by Terraform"
}

resource "aci_tenant_to_cloud_account" "cloud_acct_ten1" {
  tenant_dn        = aci_tenant.tenant1.id
  cloud_account_dn = data.aci_cloud_account.aci_cloud_account_infra.id
}

# VRFs / VNets

resource "aci_vrf" "vnet1" {
  tenant_dn = aci_tenant.tenant1.id
  name      = var.vnet1_name
}

resource "aci_vrf" "vnet2" {
  tenant_dn = aci_tenant.tenant1.id
  name      = var.vnet2_name
}

# Cloud Context Profile for VNet1 + Subnets

resource "aci_cloud_context_profile" "ctx_vnet1" {
  tenant_dn                = aci_tenant.tenant1.id
  name                     = var.cxt_vnet1
  primary_cidr             = var.vnet1_cidr
  region                   = var.vnet1_region1
  cloud_vendor             = var.cloud_vendor
  relation_cloud_rs_to_ctx = aci_vrf.vnet1.id
  hub_network              = "uni/tn-infra/gwrouterp-default" #VNet Peering is enabled by default
}

# Cloud Context Profile for VNet2 + Subnets

resource "aci_cloud_context_profile" "ctx_vnet2" {
  tenant_dn                = aci_tenant.tenant1.id
  name                     = var.cxt_vnet2
  primary_cidr             = var.vnet2_cidr
  region                   = var.vnet2_region1
  cloud_vendor             = var.cloud_vendor
  relation_cloud_rs_to_ctx = aci_vrf.vnet2.id
  hub_network              = "uni/tn-infra/gwrouterp-default" #VNet Peering is enabled by default
}

# Add Subnets for VNet1

resource "aci_cloud_subnet" "vnet1_subnets" {
  for_each           = var.vnet1_subnets
  cloud_cidr_pool_dn = data.aci_cloud_cidr_pool.vnet1_cidr.id
  name               = each.value.name
  ip                 = each.value.ip
}

# Add Subnets for VNet2

resource "aci_cloud_subnet" "vnet2_subnets" {
  for_each           = var.vnet2_subnets
  cloud_cidr_pool_dn = data.aci_cloud_cidr_pool.vnet2_cidr.id
  name               = each.value.name
  ip                 = each.value.ip
}