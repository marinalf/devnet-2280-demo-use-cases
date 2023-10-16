
### VNet Policies ###

# Application Profile for VNet1 EPG

resource "aci_cloud_applicationcontainer" "vnet1_ap" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.vnet1_ap
}

# Application Profile for VNet2 EPG

resource "aci_cloud_applicationcontainer" "vnet2_ap" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.vnet2_ap
}

# VNet1 EPG

resource "aci_cloud_epg" "vnet1_epg" {
  name                            = var.vnet1_epg
  cloud_applicationcontainer_dn   = aci_cloud_applicationcontainer.vnet1_ap.id
  relation_cloud_rs_cloud_epg_ctx = data.aci_vrf.vnet1.id
  relation_fv_rs_cons             = [aci_contract.inter_vnet.id]
  relation_fv_rs_prov             = [aci_contract.internet_access.id, aci_contract.onprem_to_cloud.id]
}

resource "aci_cloud_endpoint_selector" "vnet1_epg_selector" {
  for_each         = var.vnet1_subnets_selectors
  cloud_epg_dn     = aci_cloud_epg.vnet1_epg.id
  name             = each.value.name
  match_expression = each.value.expression
}

# VNet2 EPG

resource "aci_cloud_epg" "vnet2_epg" {
  name                            = var.vnet2_epg
  cloud_applicationcontainer_dn   = aci_cloud_applicationcontainer.vnet2_ap.id
  relation_cloud_rs_cloud_epg_ctx = data.aci_vrf.vnet2.id
  relation_fv_rs_prov             = [aci_contract.inter_vnet.id]
}

resource "aci_cloud_endpoint_selector" "vnet2_epg_selector" {
  for_each         = var.vnet2_subnets_selectors
  cloud_epg_dn     = aci_cloud_epg.vnet2_epg.id
  name             = each.value.name
  match_expression = each.value.expression
}

# Inter-VNet Contract

resource "aci_contract" "inter_vnet" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.inter_vnet_contract
  scope     = "tenant" # This allows this contract to be used by other VNets/EPG in the same tenant
}

resource "aci_contract_subject" "inter_vnet" {
  contract_dn                  = aci_contract.inter_vnet.id
  name                         = "inter-vnet-contract"
  relation_vz_rs_subj_filt_att = [data.aci_filter.default_filter.id]
}

# Cloud External EPG for Internet Access (VNet1)

resource "aci_cloud_external_epg" "vnet1_internet" {
  name                            = var.vnet1_internet
  cloud_applicationcontainer_dn   = aci_cloud_applicationcontainer.vnet1_ap.id
  relation_fv_rs_cons             = [aci_contract.internet_access.id]
  relation_cloud_rs_cloud_epg_ctx = data.aci_vrf.vnet1.id
  route_reachability              = "internet"
}

resource "aci_cloud_endpoint_selectorfor_external_epgs" "vnet1_ext_epg_selector" {
  cloud_external_epg_dn = aci_cloud_external_epg.vnet1_internet.id
  name                  = var.vnet1_selector_name
  subnet                = var.vnet1_selector_subnet
}

# Contract for Internet Access

resource "aci_contract" "internet_access" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.internet_contract
}

resource "aci_contract_subject" "internet_access" {
  contract_dn                  = aci_contract.internet_access.id
  name                         = "internet-access"
  relation_vz_rs_subj_filt_att = [data.aci_filter.default_filter.id]
}

# ER Contract on Workload Tenant for On-prem to Cloud connectivity

resource "aci_contract" "onprem_to_cloud" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.er_contract_onprem_to_cloud
  scope     = "global" # This contract will need to be imported and visible in the infra tenant
}

resource "aci_contract_subject" "onprem_to_cloud" {
  contract_dn                  = aci_contract.onprem_to_cloud.id
  name                         = "onprem_to_cloud"
  relation_vz_rs_subj_filt_att = [data.aci_filter.default_filter.id]
}

# Import contract from Workload Tenant to Infra Tenant to enable ER access to Cloud

resource "aci_imported_contract" "onprem_to_cloud" {
  tenant_dn         = data.aci_tenant.infra_tenant.id
  name              = "onprem-to-cloud-imported"
  relation_vz_rs_if = aci_contract.onprem_to_cloud.id
  depends_on        = [aci_contract.onprem_to_cloud]
}
