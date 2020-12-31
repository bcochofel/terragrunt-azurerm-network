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
  source = "github.com/bcochofel/terraform-azurerm-modules//modules/bastion_vm?ref=v1.5.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../network"]
}

dependency "network" {
  config_path = "../network"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  #mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    vnet_name = "fake-vnet-name"
    rg_name   = "fake-rg-name"
  }
}

inputs = {
  rg_name  = "rg-bastion-${local.env}-${local.region_shortname}-001"
  location = "${local.region}"

  custom_tags = {
    Environment = "${local.env}"
  }

  vnet_name = dependency.network.outputs.vnet_name
  vnet_rg   = dependency.network.outputs.rg_name

  snet_name          = "snet-bastion-${local.env}-${local.region_shortname}-001"
  snet_addr_prefixes = "10.1.1.0/24"
  pip_name           = "pip-bastion-${local.env}-${local.region_shortname}-001"
  nsg_name           = "nsg-bastion-${local.env}-${local.region_shortname}-001"
  nic_name           = "nic-bastion-${local.env}-${local.region_shortname}-001"
  vm_name            = "vm-bastion-${local.env}-${local.region_shortname}-001"

  admin_ssh_key = {
    username   = "adminuser"
    public_key = get_env("SSH_PUBLIC_KEY")
  }
}
