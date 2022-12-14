locals {
  resource_group_name = format("rg-%s-%s", var.owner_custom, var.purpose_custom)
}
data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "adb_kv" {
  name                       = format("kv-%s-%s", var.owner_custom, var.purpose_custom)
  location                   = var.location
  resource_group_name        = local.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  //public_network_access_enabled = false
  sku_name                   = "standard"


  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.private_link_subnet]
    ip_rules = [
      "137.83.217.0/24",
      "134.238.164.0/24",
      "165.1.204.0/24",
      "137.83.219.0/24",
      "165.1.201.0/24",
      "208.127.225.0/24"
    ]

  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set"
    ]
  }
}

resource "azurerm_private_dns_zone" "kv-dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = local.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "db-dns-link" {
    name = format("db-dns-%s-%s-link", var.owner_custom, var.purpose_custom)
    resource_group_name          = local.resource_group_name
    private_dns_zone_name = azurerm_private_dns_zone.kv-dns.name
    virtual_network_id = var.vnet_id
  
}

resource "azurerm_private_endpoint" "kv-pe" {
  name = format("kv-%s-%s-pe", var.owner_custom, var.purpose_custom)
  resource_group_name          = local.resource_group_name
  location                     = var.location
  subnet_id = var.private_link_subnet

    private_dns_zone_group {
    name                 = "private-kv-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv-dns.id]
  }

  private_service_connection {
    name = "kv-pe-connection"
    private_connection_resource_id = azurerm_key_vault.adb_kv.id
    is_manual_connection = false
    subresource_names = ["vault"]
  }
  
}