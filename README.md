# Azure Container Registry (ACR) with Private Endpoint

## Table of Contents

<!--ts-->

* [Table of Contents](#table-of-contents)
* [Description](#description)
* [What will be deployed](#what-will-be-deployed)
* [Prerequisites](#prerequisites)
* [Configure](#configure)
* [Test](#test)
* [Deploy](#deploy)
* [Important Post-Deployment Notes](#important-post-deployment-notes)
* [Remove](#remove)

<!--te-->

## Description

This repository contains terraform configuration to deploy an Azure Container Registry with Private Endpoint.

## Prerequisites

* Terraform version >= 1.x.x
* Appropriate Azure permissions which allow to create resources defined in the configuration.

## Configuration

For terraform configuration use the following variable files

* [terraform/environments/dev/variables.tfvars](terraform/environment/dev/variables.tfvars) - Describes unique values for dev environment
  
* `terraform/environments/<any environment dir>/variables.tfvars` - Create a directory for your specific environment like stage, prod etc.

* [terraform/variables.tf](terraform/variables.tf) - Describes all variables and sets default values which are common for all environments

Variable | Description | Type | Default Value
-------- | ------------|------| --------------
subscription_id | ID of the Azure subscription where Terraform should provision resource. Use `az account show --query id` to query subscription id | string | ""
tenant_id | Azure AD tenant ID where needed by Terraform in order to authenticate with service principal. Use `az account show --query tenantId` to query tenantId | string | ""
tags | Tags to be applied to the resources | map(string) | {}
location | Azure region where resources should be provisioned | string | "westeurope"
azure_resource_group | Name of the Azure resource group where resources should be provisioned | string | ""
acr_private_endpoint_vnet_name | Name of the virtual network where ACR private endpoint should be provisioned | string | ""
acr_private_endpoint_vnet_cidr | CIDR of the virtual network where ACR private endpoint should be provisioned | string | ""
acr_private_endpoint_subnet_name | Name of the subnet where ACR private endpoint should be provisioned | string | ""
acr_private_endpoint_subnet_cidr | CIDR of the subnet where ACR private endpoint should be provisioned | string | ""
acr_sku | SKU of the Azure Container Registry | string | "Premium"
acr_name | Name of the Azure Container Registry | string | ""
additional_source_vnets | Map of additional source virtual networks to be linked to the ACR's private DNS zone and peered to ACR private endpoint VNet.`vnet_resource_group_name` - name of the resource group where source VNet is deployed. `vnet_name` - name of the vnet which should be linked to azure private DNS. `vnet_id` - virtual network id which should be linked to azure private DNS you can grep a vnet id with azure cli `az network vnet show --name <vnet name> --resource-group <vnet resource group name> --query id -otsv` | map(object) | {}

## Test

> **Note:** Commands listed bellow written with assumption that you run them from [terraform](terraform/) directory.

Please do not forget to set `access_key` in [backend-config](/terraform/environment/dev/backend-config.tfvars) or alternatively you can retrieve storage account key with:

```bash
export access_key=$(az storage account keys list --account-name <storage-account-name> --query [0].value)
```

and pass it directly to terraform command.

In order to test terraform configuration you can use the following commands:

```bash
terraform init -backend-config="environments\dev\backend-config.tfvars" # If you keep access_key in backend-config.tfvars
terraform init -backend-config="environments\dev\backend-config.tfvars" -backend-config="access_key=$access_key" # If would like to pass access_key directly to terraform

terraform plan -var-file="environments\dev\variables.tfvars"
```

## Deploy

In order to deploy terraform configuration you can use the following commands:

```bash
terraform apply -var-file="environments\dev\variables.tfvars" --auto-approve
```

## Important Post-Deployment Notes

* If your AKS cluster is provisioned in a separate vNet then you need to link a private DNS used for the ACR private endpoint to that vNet. Same is valid for all other vNets from which you would like to resolve ACR. If you would like to link any additional vNets with ACR private DNS use this [module](terraform/modules/dns-vnet-link/)

* If you disable public access for your ACR then you need to make sure that you are able to connect to your ACR private endpoint. For example you have ExpressRoute connection to your ACR private endpoint VNet or if this connection is within Azure Network you have a peering between your ACR private endpoint VNet and VNet from which you would like to access ACR. You can setup peering by using this [module](terraform/modules/vnet-peering/)

## Remove

In order to remove terraform configuration you can use the following commands:

```bash
terraform plan -var-file="environments\dev\variables.tfvars" -destroy
terraform destroy -var-file="environments\dev\variables.tfvars" -auto-approve
```

<!-- Links -->
