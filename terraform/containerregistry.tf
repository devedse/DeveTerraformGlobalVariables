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