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
  source = "github.com/bcochofel/terraform-azurerm-modules//modules/network?ref=v1.5.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  rg_name  = "rg-base-${local.env}-${local.region_shortname}-001"
  location = "${local.region}"

  custom_tags = {
    Environment = "${local.env}"
  }

  ddos_protection_plan_name = "ddospp-base-${local.env}-${local.region_shortname}-001"
  vnet_name                 = "vnet-base-${local.env}-${local.region_shortname}-001"
  address_space             = "10.1.0.0/16"
}
