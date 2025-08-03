# Data Source: Current Caller - dynamically retriving Azure identity used by Terraform
# prevents hardcoding sensitivie identifiers
data "azurerm_client_config" "current" {}