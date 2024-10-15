resource "azurerm_virtual_network" "vnet" {
    name                = "${var.kv_owner}-KV-Example-VNET"
    location            = var.kv_location
    resource_group_name = azurerm_resource_group.kv_example.name

    address_space   = ["10.1.0.0/16"]
    dns_servers     = ["10.1.0.4", "10.1.0.5"]

    subnet {
        name                = "${var.kv_owner}-KV-Example-Subnet-1"
        address_prefixes    = ["10.1.1.0/24"]
        security_group      =  azurerm_network_security_group.sg-1.id
        service_endpoints   = ["Microsoft.KeyVault"]
    }

    subnet {
        name                = "${var.kv_owner}-KV-Example-Subnet-2"
        address_prefixes    = ["10.1.2.0/24"] 
        security_group      =  azurerm_network_security_group.sg-2.id
        service_endpoints   = ["Microsoft.KeyVault"] 
    }
}

resource "azurerm_network_security_group" "sg-1" {
    name                    = "${var.kv_owner}-KV-Example-SecurityGroup-1"
    location                = var.kv_location
    resource_group_name     = azurerm_resource_group.kv_example.name
}

resource "azurerm_network_security_group" "sg-2" {
    name                    = "${var.kv_owner}-KV-Example-SecurityGroup-2"
    location                = var.kv_location
    resource_group_name     = azurerm_resource_group.kv_example.name 
}