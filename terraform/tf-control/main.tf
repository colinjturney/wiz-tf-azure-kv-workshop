module "tf-azure-kv-demo" {
    source = "../modules/tf-azure-kv-demo"

    kv_owner               = var.kv_owner
    kv_location            = var.kv_location
    kv_ingress_prefix      = var.kv_ingress_prefix
}