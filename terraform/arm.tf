variable subscriptionId { }

variable servicePrincipalId { }
variable servicePrincipalKey { }
variable tenantId { }

variable environment { }
variable resourceGroupName { }
variable prefix { }

module "global_variables" {
  source = "./modules/global_variables"

  applicationShortName = "${var.prefix}TFComp"
  applicationName = "${var.prefix}TFAzureComponents"
}

provider "azurerm" {
  version = "=2.17.0"
  subscription_id = var.subscriptionId
  client_id       = var.servicePrincipalId
  client_secret   = var.servicePrincipalKey
  tenant_id       = var.tenantId

  features {}
}

