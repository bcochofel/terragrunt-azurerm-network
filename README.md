# azurerm-terragrunt-network

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![GitHub license](https://img.shields.io/github/license/bcochofel/azurerm-terragrunt-network.svg)](https://github.com/bcochofel/azurerm-terragrunt-network/blob/master/LICENSE)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/bcochofel/azurerm-terragrunt-network)](https://github.com/bcochofel/azurerm-terragrunt-network/tags)
[![GitHub issues](https://img.shields.io/github/issues/bcochofel/azurerm-terragrunt-network.svg)](https://github.com/bcochofel/azurerm-terragrunt-network/issues/)
[![GitHub forks](https://img.shields.io/github/forks/bcochofel/azurerm-terragrunt-network.svg?style=social&label=Fork&maxAge=2592000)](https://github.com/bcochofel/azurerm-terragrunt-network/network/)
[![GitHub stars](https://img.shields.io/github/stars/bcochofel/azurerm-terragrunt-network.svg?style=social&label=Star&maxAge=2592000)](https://github.com/bcochofel/azurerm-terragrunt-network/stargazers/)

This repository implements Multi Environment Multi Region Azure Network using Terragrunt.

You can use this has a starting point to deploy Infrastructure on several environments and regions.

# Requirements

* [`pre-commit`](https://pre-commit.com/#install)
* [`TFLint`](https://github.com/terraform-linters/tflint) required for `tflint` hook.

You can also use [pre-commit](https://pre-commit.com/#install). After installing
`pre-commit` just execute:

```ShellSession
pre-commit install
```

You can run specific hooks on all files:

```ShellSession
pre-commit run terraform-fmt --all-files
```

You can force all the hooks to run with the following command:

```ShellSession
pre-commit run --all-files
```

# How is the code organized?

The code in this repo is based on [this](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example) repo.

# How to deploy the code

You can use Terragrunt to deploy a single module, all modules in a region or all modules in an environment.

You can use environment variables for Azure authentication with something like this:

```ShellSession
export ARM_SUBSCRIPTION_ID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
export ARM_CLIENT_ID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
export ARM_CLIENT_SECRET=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
export ARM_TENANT_ID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
```

The code defines remote backend (see [here](environments/terragrunt.hcl)) assuming the following environment variables:

* `TF_BACKEND_RESOURCE_GROUP_NAME`: Resource Group Name
* `TF_BACKEND_STORAGE_ACCOUNT_NAME`: Storage Account Name
* `TF_BACKEND_CONTAINER_NAME`: Container Name

The backend key used is based on the folder hierarchy concatenate with `terraform.tfstate`.

## Deploy single module

* cd into the module's folder (e.g. `cd environments/stage/northeurope/network`).
* Run `terragrunt plan` to see the changes you're about to apply.
* If everything looks good run `terragrunt apply`.

## Deploy all the modules in a region

* cd into the region folder (e.g. `cd environments/stage/northeurope`).
* Run `terragrunt plan-all` to see all the changes you're about to apply.
* If everything looks good run `terragrunt apply-all`.

## Deploy all the modules in an environment

* cd into the environment folder (e.g. `cd environments/stage`).
* Run `terragrunt plan-all` to see all the changes you're about to apply.
* If everything looks good run `terragrunt apply-all`.

# References

* [Out-of-the-box pre-commit hooks](https://github.com/pre-commit/pre-commit-hooks)
* [Gruntwork pre-commit hooks](https://github.com/gruntwork-io/pre-commit)
* [Naming rules and restrictions for Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork)
* [Resource providers for Azure services](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers)
* [Azure Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
* [Azure Recommended abbreviations for Azure resource types](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
* [Terraform Versions Constraints](https://www.terraform.io/docs/configuration/version-constraints.html)
* [Terragrunt Docs](https://terragrunt.gruntwork.io/docs/)
* [terragrunt-infrastructure-modules-example](https://github.com/gruntwork-io/terragrunt-infrastructure-modules-example)
* [terragrunt-infrastructure-live-example](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example)
