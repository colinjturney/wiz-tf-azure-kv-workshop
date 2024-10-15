data "azurerm_client_config" "current" {}

data "azurerm_subnet" "subnet-1" {
    name                    = "${var.kv_owner}-KV-Example-Subnet-1"
    virtual_network_name    = azurerm_virtual_network.vnet.name 
    resource_group_name     = azurerm_resource_group.kv_example.name 

    depends_on = [ azurerm_virtual_network.vnet ]
}

data "azurerm_subnet" "subnet-2" {
    name                    = "${var.kv_owner}-KV-Example-Subnet-2"
    virtual_network_name    = azurerm_virtual_network.vnet.name 
    resource_group_name     = azurerm_resource_group.kv_example.name 

    depends_on = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_key_vault" "kv-private-1" {
    name                    = "${var.kv_owner}-KV-1"
    location                = var.kv_location
    resource_group_name     = azurerm_resource_group.kv_example.name
    tenant_id               = data.azurerm_client_config.current.tenant_id

    sku_name                        = "standard"
    purge_protection_enabled        = true
    enabled_for_disk_encryption     = false
    public_network_access_enabled   = false
    enable_rbac_authorization       = false
}

resource "azurerm_key_vault" "kv-pubvnet-2" {
    name                    = "${var.kv_owner}-KV-2"
    location                = var.kv_location
    resource_group_name     = azurerm_resource_group.kv_example.name
    tenant_id               = data.azurerm_client_config.current.tenant_id

    sku_name                        = "standard"
    purge_protection_enabled        = true
    enabled_for_disk_encryption     = false
    public_network_access_enabled   = true
    enable_rbac_authorization       = true

    network_acls {
      bypass = "AzureServices"
      default_action = "Deny"
      virtual_network_subnet_ids = [ data.azurerm_subnet.subnet-1.id ]
    }
}

resource "azurerm_key_vault" "kv-pub-3" {
    name                    = "${var.kv_owner}-KV-3"
    location                = var.kv_location
    resource_group_name     = azurerm_resource_group.kv_example.name
    tenant_id               = data.azurerm_client_config.current.tenant_id

    sku_name                        = "standard"
    purge_protection_enabled        = true
    enabled_for_disk_encryption     = false
    public_network_access_enabled   = true
    enable_rbac_authorization       = true

    network_acls {
      bypass = "AzureServices"
      default_action = "Deny"
      virtual_network_subnet_ids = [ data.azurerm_subnet.subnet-1.id, data.azurerm_subnet.subnet-2.id]
    }
}

resource "azurerm_key_vault" "kv-ap-4" {
    name                    = "${var.kv_owner}-KV-4"
    location                = var.kv_location
    resource_group_name     = azurerm_resource_group.kv_example.name
    tenant_id               = data.azurerm_client_config.current.tenant_id

    sku_name                        = "standard"
    purge_protection_enabled        = true
    enabled_for_disk_encryption     = false

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        key_permissions = [
        "Get",
        ]

        secret_permissions = [
        "Get",
        ]

        storage_permissions = [
        "Get",
        ]
    }

}