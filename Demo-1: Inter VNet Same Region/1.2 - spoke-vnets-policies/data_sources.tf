
data "aci_tenant" "infra_tenant" {
  name = "infra"
}

data "aci_tenant" "tenant1" {
  name = var.tenant_name
}

data "aci_vrf" "vnet1" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.vnet1_name
}

data "aci_vrf" "vnet2" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.vnet2_name
}  

data "aci_filter" "default_filter" {
  tenant_dn = "uni/tn-common"
  name      = "default" # Existing default filter allowing any traffic
}

