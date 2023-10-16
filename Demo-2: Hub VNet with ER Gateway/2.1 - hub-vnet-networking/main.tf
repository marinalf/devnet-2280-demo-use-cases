# Add Services VRF to host ER and L4-L7 Servies in the Hub VNet

resource "aci_vrf" "services_vrf" {
  tenant_dn = data.aci_tenant.infra_tenant.id 
  name      = var.services_vrf
}

#Note: This secondary VRF will not create any new VNet on Azure, it is just a logical container to host the Express Route as well as new CIDRs to be used by L4-L7 services. 
