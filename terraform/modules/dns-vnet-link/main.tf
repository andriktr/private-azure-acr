resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  name                  = "${var.vnet_name}-to-${var.private_dns_zone_name}-link"
  private_dns_zone_name = var.private_dns_zone_name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.vnet_id
  tags                  = var.tags
}