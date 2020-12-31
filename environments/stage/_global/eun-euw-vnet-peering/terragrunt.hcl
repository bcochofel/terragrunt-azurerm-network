locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env              = local.environment_vars.locals.environment
  region           = local.region_vars.locals.azure_region
  region_shortname = local.region_vars.locals.az_region_shortname
}

terraform {
  source = "github.com/bcochofel/terraform-azurerm-modules//modules/vnet_peering?ref=v1.5.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../northeurope/vnet", "../../westeurope/vnet"]
}

dependency "vneteun" {
  config_path = "../../northeurope/vnet"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  #mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    vnet_name = "fake-vnet-eun-name"
    vnet_id   = "fake-vnet-eun-id"
    rg_name   = "fake-rg-eun-name"
  }
}

dependency "vneteuw" {
  config_path = "../../westeurope/vnet"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  #mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    vnet_name = "fake-vnet-euw-name"
    vnet_id   = "fake-vnet-euw-id"
    rg_name   = "fake-rg-euw-name"
  }
}

inputs = {
  vnet1_rg   = dependency.vneteun.outputs.rg_name
  vnet1_name = dependency.vneteun.outputs.vnet_name
  vnet1_id   = dependency.vneteun.outputs.vnet_id
  vnet2_rg   = dependency.vneteuw.outputs.rg_name
  vnet2_name = dependency.vneteuw.outputs.vnet_name
  vnet2_id   = dependency.vneteuw.outputs.vnet_id
}
