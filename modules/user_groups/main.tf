# Create Azure AD Group for Owners
resource "azuread_group" "owner_group" {
  display_name     = var.owner_group_name
  security_enabled = true
}

# Create Azure AD Group for Operators (Contributor)
resource "azuread_group" "operator_group" {
  display_name     = var.operator_group_name
  security_enabled = true
}

# Create Azure AD Group for Read-only (Reader)
resource "azuread_group" "readonly_group" {
  display_name     = var.readonly_group_name
  security_enabled = true
}

# Assign Owner role to the Owner group
resource "azurerm_role_assignment" "owner_role_assignment" {
  principal_id         = azuread_group.owner_group.object_id
  role_definition_name = "Owner"
  scope                = var.resource_group_id
}

# Assign Contributor role to the Operator group
resource "azurerm_role_assignment" "operator_role_assignment" {
  principal_id         = azuread_group.operator_group.object_id
  role_definition_name = "Contributor"
  scope                = var.resource_group_id
}

# Assign Reader role to the Read-only group
resource "azurerm_role_assignment" "readonly_role_assignment" {
  principal_id         = azuread_group.readonly_group.object_id
  role_definition_name = "Reader"
  scope                = var.resource_group_id
}
