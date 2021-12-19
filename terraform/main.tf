# Create azure resource group
resource "azurerm_resource_group" "acr_resource_group" {
  name     = var.azure_resource_group
  location = var.location
  tags     = var.tags
}

# Create azure virtual network
resource "azurerm_virtual_network" "acr_private_endpoint_vnet" {
  name                = azurerm_resource_group.acr_resource_group.name
  location            = var.location
  resource_group_name = var.azure_resource_group  
  address_space       = [var.acr_private_endpoint_vnet_cidr]
}

# Create azure subnet for acr private endpoint
resource "azurerm_subnet" "acr_private_endpoint_subnet" {
  name                                           = var.acr_private_endpoint_subnet_name
  resource_group_name                            = azurerm_resource_group.acr_resource_group.name
  virtual_network_name                           = azurerm_virtual_network.acr_private_endpoint_vnet.name
  address_prefixes                               = [var.acr_private_endpoint_subnet_cidr]
  enforce_private_link_endpoint_network_policies = true

}

# Create azure container registry
resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.acr_resource_group.name
  admin_enabled                 = false
  sku                           = var.acr_sku
  public_network_access_enabled = false
  tags                          = var.tags 
}

resource "azurerm_private_dns_zone" "acr_private_dns_zone" {
  name                = "privatelink.azurecr.io"
  resource_group_name =  azurerm_resource_group.acr_resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_private_dns_zone_virtual_network_link" {
  name                  = "${var.acr_name}-private-dns-zone-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.acr_private_dns_zone.name
  resource_group_name   = azurerm_resource_group.acr_resource_group.name
  virtual_network_id    = azurerm_virtual_network.acr_private_endpoint_vnet.id
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "${var.acr_name}-private-endpoint"
  resource_group_name = azurerm_resource_group.acr_resource_group.name
  location            = var.location
  subnet_id           = azurerm_subnet.acr_private_endpoint_subnet.id
  tags                = var.tags
  
  private_service_connection {
    name                           = "${var.acr_name}-service-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names = [
      "registry"
    ]
  }
  
  private_dns_zone_group {
    name = "${var.acr_name}-private-dns-zone-group"
    
    private_dns_zone_ids = [
      azurerm_private_dns_zone.acr_private_dns_zone.id
    ]  
  }
 
  depends_on = [
    azurerm_virtual_network.acr_private_endpoint_vnet,
    azurerm_subnet.acr_private_endpoint_subnet,
    azurerm_container_registry.acr
  ]
}

module "name" {
  source = "./modules/dns-vnet-link"
  
  for_each                     = var.additional_source_vnets
  vnet_name                    = each.value.vnet_name
  vnet_id                      = each.value.vnet_id
  acr_resource_group_name      = azurerm_resource_group.acr_resource_group.name
  acr_private_dns_zone_name    = azurerm_private_dns_zone.acr_private_dns_zone.name
  tags                         = var.tags
}