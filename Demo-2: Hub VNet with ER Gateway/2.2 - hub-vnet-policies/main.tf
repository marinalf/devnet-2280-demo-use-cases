## Config for ER on Hub VNet ##

# Shared Resources AP

resource "aci_cloud_applicationcontainer" "services_ap" {
  tenant_dn = data.aci_tenant.infra_tenant.id
  name      = var.services_ap
}

# External  Cloud Endpoint Group for ER + Allowed On-Prem Prefixes/Subnets

resource "aci_cloud_external_epg" "er_epg" {
  name                            = var.er_epg
  cloud_applicationcontainer_dn   = aci_cloud_applicationcontainer.services_ap.id
  relation_cloud_rs_cloud_epg_ctx = data.aci_vrf.services_vrf.id
  route_reachability              = "site-ext"
  relation_fv_rs_prov             = [aci_contract.cloud_to_onprem.id]
  relation_fv_rs_cons_if          = [data.aci_imported_contract.onprem_to_cloud.id] # To be enabled only after the contract is imported from workload tenant.
}

resource "aci_cloud_endpoint_selectorfor_external_epgs" "onprem_subnets" {
  for_each              = var.onprem_subnets
  cloud_external_epg_dn = aci_cloud_external_epg.er_epg.id
  name                  = each.value.name
  subnet                = each.value.subnet

}

# ER Contract on Infra Tenant for Cloud to On-prem connectivity

resource "aci_contract" "cloud_to_onprem" {
  tenant_dn = data.aci_tenant.infra_tenant.id
  name      = var.er_contract_cloud_to_onprem
  scope     = "global" # This contract will need to be imported and visible in the user/workload tenant
}

resource "aci_contract_subject" "cloud_to_onprem" {
  contract_dn                  = aci_contract.cloud_to_onprem.id
  name                         = "cloud_to_onprem"
  relation_vz_rs_subj_filt_att = [data.aci_filter.default_filter.id]
}

# Import contract from Infra Tenant to Workload Tenant to enable Cloud to ER access

resource "aci_imported_contract" "cloud_to_onprem" {
  tenant_dn         = data.aci_tenant.tenant1.id
  name              = "cloud-to-onprem-imported"
  relation_vz_rs_if = aci_contract.cloud_to_onprem.id
  depends_on        = [aci_contract.cloud_to_onprem]
}
