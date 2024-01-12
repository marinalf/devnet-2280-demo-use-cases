
data "aci_tenant" "infra_tenant" {
  name = "infra"
}

data "aci_cloud_account" "aci_cloud_account_infra" {
  tenant_dn  = "uni/tn-infra"
  account_id = var.subscription_id
  vendor     = "azure"
}

data "aci_vrf" "services_vrf" {
  tenant_dn = data.aci_tenant.infra_tenant.id 
  name      = var.services_vrf
}

data "aci_cloud_context_profile" "hub_vnet" {
  tenant_dn = data.aci_tenant.infra_tenant.id
  name      = "ct_ctxprofile_uksouth" # Hub VNet Cloud Context Profile (overlay-1)
}