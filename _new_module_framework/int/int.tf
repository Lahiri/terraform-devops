## This file deploys the module for the integration test.
# All values used must be valid because the resources must be actually deployed, even if they will be automatically destroyed soon after.
# source is always "../" because the module to test is in the parent folder.

/*
module "module_name_int" {
  source = "../"

  resource_group_name  = "int-test-rg"
  location             = "westeurope"
  disk_name            = "int-test-disk-01"
  storage_account_type = "Standard_LRS"
}
*/