# DeveTerraformGlobalVariables

Hi all,

I've been struggling for the past hour with implementing global variables. Due to some (probably good) reasons this is apparently not a good idea however there's quite a good workaround. I've dug through a lot of github issues, blogposts and whatever but no one seems to have made a very simple, basic solution for this.

The reason I want this is to be able to reuse an application name that's made up of `'${prefix}CoolApplication'`. I don't want to type this everywhere, I simply want to use `'${applicationName}'` everywhere.

That's why I present to you, a working solution for implementing global variables.

Directory structure:
```
|   arm.tf                 (Here we define the actual values of the global_variables)
|   resourcegroup.tf       (Skipped from this sample)
|   state.tf               (Skipped from this sample)
|   containerregistry.tf   (Let's make use of the module here)
|
\---modules
    \---global_variables
            output.tf
            variables.tf
```

Let's start with defining the module that we build to store our global variables:

**modules\global_variables\variables.tf**
```
variable applicationName { }
variable applicationShortName { }
```

**modules\global_variables\output.tf**
```
output "applicationName" {
  value = var.applicationName
}

output "applicationShortName" {
  value = var.applicationShortName
}
```

Now to actually use this module for defining global variables:
**arm.tf** (The provider for our Terraform deployment)
```
variable subscriptionId { }

variable servicePrincipalId { }
variable servicePrincipalKey { }
variable tenantId { }

variable environment { }
variable resourceGroupName { }
variable prefix { }

# Here we define the actual values. We can make use of any input variables that we've defined above.
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
```

We can then easily reuse these variables inside any other .tf file:
**containerregistry.tf**
```
resource "azurerm_container_registry" "acr" {
  name                     = "${lower(module.global_variables.applicationName)}acr${var.environment}"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  sku                      = "Basic"
  admin_enabled            = true
}

resource "azurerm_key_vault_secret" "keyvaultsecret-acr-id" {
  name         = "${module.global_variables.applicationName}-acr-id"
  value        = azurerm_container_registry.acr.id
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "keyvaultsecret-acr-loginserver" {
  name         = "${module.global_variables.applicationName}-acr-loginserver"
  value        = azurerm_container_registry.acr.login_server
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "keyvaultsecret-acr-adminusername" {
  name         = "${module.global_variables.applicationName}-acr-adminusername"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "keyvaultsecret-acr-adminpassowrd" {
  name         = "${module.global_variables.applicationName}-acr-adminpassword"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = azurerm_key_vault.keyvault.id
}
```

**Summary**

As you can see in the sample above we can easily reuse globally defined variables without having to type `"${var.prefix}${var.applicationName}...."`. Hopefully this sample helps someone.

This issue probably doesn't comply with any guidelines on writing issues for Terraform, feel free to downvote :), I hope I've helped someone fix their issues.
