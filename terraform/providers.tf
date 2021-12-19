terraform {
  required_version = ">= 1.0.8"  
  backend "azurerm" {}

  required_providers {
    azurerm = {
      version = "~> 2.90.0"
    }
    azuread = {
      version = "~> 1.6.0"
    }
  }
}

provider "azurerm" {
  features {} 
  skip_provider_registration = true
}
