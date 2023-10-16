
data "aci_tenant" "infra_tenant" {
  name = "infra"
}

data "aci_tenant" "tenant1" {
  name = var.tenant_name
}

data "aci_cloud_account" "aci_cloud_account_infra" {
  tenant_dn  = "uni/tn-infra"
  account_id = var.subscription_id
  vendor     = "azure"
}

data "aci_vrf" "services_vrf" {
  tenant_dn = "uni/tn-infra"
  name      = "hub-services"
}

# Data Sources used for ER

data "aci_filter" "default_filter" {
  tenant_dn = "uni/tn-common"
  name      = "default" # Existing default filter allowing any traffic
}

# To be used only after the contract is imported from workload tenant

data "aci_imported_contract" "onprem_to_cloud" {
  tenant_dn = data.aci_tenant.infra_tenant.id
  name      = "onprem-to-cloud-imported"
}

