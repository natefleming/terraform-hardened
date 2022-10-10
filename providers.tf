terraform {
  required_version = ">=0.12"

required_providers {
    databricks = {
        source = "databricks/databricks"
        version = "1.2.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.21.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "databricks" {
   // azure_workspace_resource_id = azurerm_databricks_workspace.databricks_workspace.id
    azure_workspace_resource_id = module.adb.adb_id
}

provider "azurerm" {
  features {}
  # client_id = ""
  # client_secret = ""
  # tenant_id = ""
}