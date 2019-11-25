### MAIN.TF contrains the provider and resource definition.

/*
resource "azurerm_managed_disk" "example_disk" {
  create_option        = "Empty"
  location             = var.location
  name                 = var.disk_name
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
}
*/
