
data "aci_tenant" "infra_tenant" {
  name = "infra"
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

data "aci_cloud_applicationcontainer" "services_ap" {
  tenant_dn = data.aci_tenant.infra_tenant.id
  name      = var.services_ap
}

# Data Sources used for FW mgmt access

data "aci_filter" "ssh_https" {
  tenant_dn = "uni/tn-infra"
  name      = "ssh-https" # Existing SSH & HTTPs filter allowing mgmt access to CNC/CCRs public IPs
}

data "aci_cloud_external_epg" "ext_networks" {
  cloud_applicationcontainer_dn = "uni/tn-infra/cloudapp-cloud-infra"
  name                          = "ext-networks"

}

# Data Sources used for NLB

data "aci_cloud_context_profile" "hub_vnet" {
  tenant_dn = data.aci_tenant.infra_tenant.id
  name      = "ct_ctxprofile_uksouth" # Hub VNet Cloud Context Profile (overlay-1)
}

data "aci_cloud_cidr_pool" "hub_services_cidr" {
  cloud_context_profile_dn = data.aci_cloud_context_profile.hub_vnet.id
  addr                     = var.hub_services_cidr
}

data "aci_cloud_subnet" "fw_nlb_subnet" {
  cloud_cidr_pool_dn = data.aci_cloud_cidr_pool.hub_services_cidr.id
  ip                 = "12.1.3.0/24"
}

# Data Sources used for Service Graph

data "aci_tenant" "tenant1" {
  name = var.tenant_name
}