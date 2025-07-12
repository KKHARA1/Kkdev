terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = "ba578ce6-e042-4ed5-9e0b-99d4cc681a62"
}
