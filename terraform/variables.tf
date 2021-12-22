variable "subscription_id" {
  description = "ID of the Azure subscription where Terraform should provision resource. Use azure cli command to query id: az account show --query id"
  type        = string
  default     = ""
}

variable "tenant_id" {
  description = "Azure AD tenant ID where needed by Terraform in order to authenticate with service principal. Use azure cli command to query id: az account show --query tenantId"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to be applied to the resources"
  type = map(string)
  default = {}
}

variable "location" {
  description = "Azure region where resources should be provisioned"
  type        = string
  default     = "westeurope"
}
variable "azure_resource_group" {
  description = "Name of the Azure resource group where resources will be provisioned"
  type = string
  default = ""
}
  
variable "acr_private_endpoint_vnet_name" {
  description = "Name of the virtual network where ACR private endpoint should be provisioned"
  type = string
  default = ""
}

variable "acr_private_endpoint_vnet_cidr" {
  description = "CIDR of the virtual network where ACR private endpoint should be provisioned"
  type = string
  default = ""
}

variable "acr_private_endpoint_subnet_name" {
  description = "Name of the Azure subnet for ACR"
  type = string
  default = ""
}

variable "acr_private_endpoint_subnet_cidr" {
  description = "CIDR of the subnet where ACR private endpoint should be provisioned"
  type = string
  default = ""
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type = string
  default = ""
}

variable "acr_sku" {
  description = "SKU of the Azure Container Registry"
  default = "Premium"

  validation {
    condition     = contains(["Premium"], var.acr_sku)
    error_message = "Argument \"acr_sku\" must be either \"Premium\" in order to support private endpoints."
  }
}

variable "additional_source_vnets" {
  description = "Map of additional source virtual networks to be linked to the ACR's private DNS zone. Comment this out if you don't need to link additional source virtual networks."

  type = map(object({
        vnet_resource_group_name = string
        vnet_name       = string
        vnet_id         = string
        })
  )

  # Example:
  # "additional_source_vnets": {
  #   "vnet1": {
  #       "vnet_resource_group_name": "rg1",
  #       "vnet_name": "vnet1",
  #       "vnet_id": "vnet1-id"  
  #   },
  #   "vnet2": {
  #       "vnet_resource_group_name": "rg2",
  #       "vnet_name": "vnet2",
  #       "vnet_id": "vnet2-id"  
  #   },
  #}
}