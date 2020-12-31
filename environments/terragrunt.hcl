locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract the variables we need for easy access
  environment         = local.environment_vars.locals.environment
  azure_region        = local.region_vars.locals.azure_region
  az_region_shortname = local.region_vars.locals.az_region_shortname
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  version = "~> 2.41.0"
  features {}
}
EOF
}

remote_state {
  backend = "azure"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = get_env("TF_BACKEND_RESOURCE_GROUP_NAME", "rg-demolab-tf-001")
    storage_account_name = get_env("TF_BACKEND_STORAGE_ACCOUNT_NAME", "stdemolabtf001")
    container_name       = get_env("TF_BACKEND_CONTAINER_NAME", "scdemolabtf001")
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

terraform {
  before_hook "env" {
    commands = ["validate", "plan"]
    execute  = ["env"]
  }

  after_hook "tflint" {
    commands = ["validate"]
    execute  = ["tflint", "--module", "."]
  }

  after_hook "conftest" {
    commands = ["show"]
    execute  = ["conftest", "--version"]
  }
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.environment_vars.locals,
  local.region_vars.locals,
)
