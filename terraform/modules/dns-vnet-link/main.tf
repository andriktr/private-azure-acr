resource "azurerm_private_dns_zone_virtual_network_link" "acr_private_dns_zone_virtual_network_link" {
  name                  = "${var.vnet_name}-acr-private-dns-zone-link"
  private_dns_zone_name = var.acr_private_dns_zone_name
  resource_group_name   = var.acr_resource_group_name
  virtual_network_id    = var.vnet_id
  tags                  = var.tags
}