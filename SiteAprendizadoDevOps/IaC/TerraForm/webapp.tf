provider "azurerm" {
    version = "~>2.0"
    features {}
}

terraform {
  backend "azurerm" {}
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "terraformrg" {
    name = "multideployterraform-rg"
    location = "eastus2"
}

resource "azurerm_app_service_plan" "serviceplan" {
    name                = "multideployterraform-sp"
    location            = azurerm_resource_group.terraformrg.location
    resource_group_name = azurerm_resource_group.terraformrg.name
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "appService" {
    name                = "multideployterraform"
    location            = azurerm_resource_group.terraformrg.location
    resource_group_name = azurerm_resource_group.terraformrg.name
    app_service_plan_id = azurerm_app_service_plan.serviceplan.id
    site_config {
        windows_fx_version = "DOTNETCORE|5.0"
        dotnet_framework_version = "v5.0"
    }
}
