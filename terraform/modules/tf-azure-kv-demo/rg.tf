resource "azurerm_resource_group" "kv_example" {
  name     = "${var.kv_owner}-KV-Example"
  location = var.kv_location
}