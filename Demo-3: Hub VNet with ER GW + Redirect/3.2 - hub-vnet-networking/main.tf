# Firewall CIDR/Subnets (inclusive of Load Balancer subnet)

resource "aci_cloud_cidr_pool" "fw_cidr" {
  cloud_context_profile_dn = data.aci_cloud_context_profile.hub_vnet.id
  addr                     = var.fw_cidr
  primary                  = "no"
}

resource "aci_cloud_subnet" "fw_subnets" {
  for_each                        = var.fw_subnets
  cloud_cidr_pool_dn              = aci_cloud_cidr_pool.fw_cidr.id
  name                            = each.value.name
  ip                              = each.value.ip
  relation_cloud_rs_subnet_to_ctx = data.aci_vrf.services_vrf.id
  zone                            = "uni/clouddomp/provp-azure/region-${var.hub_region}/zone-default" 
}

# Enable Hub VNet Peering

resource "aci_rest_managed" "disable_enable_hub_networking" {
  dn       = "uni/tn-infra/infranetwork-default/intnetwork-default/provider-azure-region-australiaeast/regiondetail"
  class_name = "cloudtemplateRegionDetail"
  depends_on = [aci_cloud_subnet.fw_subnets]
  content = {
    "hubNetworkingEnabled" = "yes" # Disable/Enable VNet Peering (Hub Networking)
  }
}