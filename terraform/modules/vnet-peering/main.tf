resource "azurerm_virtual_network_peering" "destination_vnet_to_source_vnet_peering" {
  name                         = "${var.destination_vnet_name}-to-${var.source_vnet_name}-peering"
  resource_group_name          = var.destination_resource_group_name
  virtual_network_name         = var.destination_vnet_name
  remote_virtual_network_id    = var.source_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  
}  

resource "azurerm_virtual_network_peering" "source_vnet_to_destination_vnet_peering" {
  name                         = "${var.source_vnet_name}-to-${var.destination_vnet_name}-peering"
  resource_group_name          = var.source_vnet_resource_group_name
  virtual_network_name         = var.source_vnet_name
  remote_virtual_network_id    = var.destination_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}