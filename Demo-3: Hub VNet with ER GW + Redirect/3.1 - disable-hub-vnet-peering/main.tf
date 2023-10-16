# Disable Hub VNet Peering to add new CIDR

resource "aci_rest_managed" "disable_enable_hub_networking" {
  dn       = "uni/tn-infra/infranetwork-default/intnetwork-default/provider-azure-region-australiaeast/regiondetail"
  class_name = "cloudtemplateRegionDetail"
  content = {
    "hubNetworkingEnabled" = "no" # Disable/Enable VNet Peering (Hub Networking)
  }
}
