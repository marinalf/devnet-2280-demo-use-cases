# FW Mgmt Cloud Endpoint Group + Contract to allow SSH/HTTPs acccess

resource "aci_cloud_epg" "fw_mgmt_epg" {
  name                            = var.fw_mgmt_epg
  cloud_applicationcontainer_dn   = data.aci_cloud_applicationcontainer.services_ap.id
  relation_fv_rs_prov             = [aci_contract.fw_mgmt_access.id]
  relation_cloud_rs_cloud_epg_ctx = data.aci_vrf.services_vrf.id
}

resource "aci_cloud_endpoint_selector" "fw_mgmt" {
  cloud_epg_dn     = aci_cloud_epg.fw_mgmt_epg.id
  name             = var.fw_mgmt_subnet_name
  match_expression = var.fw_mgmt_subnet # This requires the Hub VNet to be configured already with an additional CIDR
}

resource "aci_contract" "fw_mgmt_access" {
  tenant_dn = data.aci_tenant.infra_tenant.id
  name      = var.fw_mgmt_contract
  scope     = "tenant"
}

resource "aci_contract_subject" "fw_mgmt_access" {
  contract_dn                  = aci_contract.fw_mgmt_access.id
  name                         = "fw_subject"
  relation_vz_rs_subj_filt_att = [data.aci_filter.ssh_https.id]
}

# Associate fw_mgmt_access contract as consumer on existing "ext_networks" Cloud Endpoint Group

resource "aci_epg_to_contract" "ext_networks" {
  application_epg_dn = data.aci_cloud_external_epg.ext_networks.id
  contract_dn        = aci_contract.fw_mgmt_access.id
  contract_type      = "consumer"
}

# Create Logical Firewall Representation (3rd party example)

resource "aci_cloud_l4_l7_third_party_device" "pa_fw" {
  tenant_dn                     = data.aci_tenant.infra_tenant.id
  name                          = var.fw_name
  relation_cloud_rs_ldev_to_ctx = data.aci_vrf.services_vrf.id

  interface_selectors {
    allow_all = "yes"
    name      = "trust"
    end_point_selectors {
      match_expression = "custom:internal=='trust'"
      name             = "trust"
    }
  }
  interface_selectors {
    allow_all = "yes"
    name      = "untrust"
    end_point_selectors {
      match_expression = "custom:external=='untrust'"
      name             = "untrust"
    }
  }
}

# Create Native Network Load Balancer for Firewall

resource "aci_cloud_l4_l7_native_load_balancer" "fw_nlb" {
  tenant_dn                              = data.aci_tenant.infra_tenant.id
  name                                   = var.fw_nlb_name
  relation_cloud_rs_ldev_to_cloud_subnet = [data.aci_cloud_subnet.fw_nlb_subnet.id]
  allow_all                              = "yes"
  is_static_ip                           = "yes" # Refer to https://github.com/CiscoDevNet/terraform-provider-aci/issues/1129
  scheme                                 = "internal"
  cloud_l4l7_load_balancer_type          = "network"
}

# Create Service Graph for FW and NLB

resource "aci_l4_l7_service_graph_template" "fw_sg" {
  tenant_dn                         = data.aci_tenant.tenant1.id
  name                              = var.fw_sg
  l4_l7_service_graph_template_type = "cloud"
}

resource "aci_function_node" "nlb" {
  l4_l7_service_graph_template_dn     = aci_l4_l7_service_graph_template.fw_sg.id
  name                                = "fw-nlb"
  func_template_type                  = "CLOUD_NATIVE_LB"
  routing_mode                        = "Redirect" # No option to set Redirect on consumer and provider connector types
  relation_vns_rs_node_to_cloud_l_dev = aci_cloud_l4_l7_native_load_balancer.fw_nlb.id
}

resource "aci_function_node" "pan_fw" { # Refer to https://github.com/CiscoDevNet/terraform-provider-aci/issues/1130
  l4_l7_service_graph_template_dn      = aci_l4_l7_service_graph_template.fw_sg.id
  name                                 = "pan-fw"
  func_template_type                   = "FW_ROUTED"
  relation_vns_rs_node_to_cloud_l_dev  = aci_cloud_l4_l7_third_party_device.pa_fw.id
  l4_l7_device_interface_consumer_name = "trust"
  l4_l7_device_interface_provider_name = "untrust"
}











/*
Waiting on https://github.com/CiscoDevNet/terraform-provider-aci/issues/1130

resource "aci_function_node" "nlb" {
  l4_l7_service_graph_template_dn     = aci_l4_l7_service_graph_template.fw_sg.id
  name                                = "fw-nlb"
  routing_mode                        = "Redirect"
  relation_vns_rs_node_to_cloud_l_dev = aci_cloud_l4_l7_native_load_balancer.fw_nlb.id
}

resource "aci_function_node" "pan_fw" {
  l4_l7_service_graph_template_dn      = aci_l4_l7_service_graph_template.fw_sg.id
  name                                 = "pan-fw"
  func_template_type                   = "FW_ROUTED"
  relation_vns_rs_node_to_cloud_l_dev  = aci_cloud_l4_l7_third_party_device.pa_fw.id
  l4_l7_device_interface_consumer_name = "trust"
  l4_l7_device_interface_provider_name = "untrust"
}
*/