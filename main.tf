# Local values for conditional logic and naming conventions
locals {
  # Determine whether to create custom role definition based on non-empty content
  include_custom_role_definition = var.custom_role_definition != ""
  
  # Determine whether to create Azure policy based on non-empty content
  include_azure_policy = var.azure_policy != ""
  
  # Normalize management group name for consistent naming (lowercase, spaces to hyphens)
  normalised_name = replace(lower(var.display_name), " ", "-")
  
  # Generate policy prefix by combining user prefix with normalized name
  # Handle edge cases where prefix might be empty or contain double hyphens
  policy_prefix = trimprefix(replace("${var.policy_prefix}-${local.normalised_name}", "--", "-"), "-")
}

# Create the management group with the specified name and parent
resource "azurerm_management_group" "this" {
  display_name                   = var.display_name
  name                          = var.name
  parent_management_group_id    = var.parent_management_group_id
  subscription_ids              = var.subscription_ids
}

# Create custom role definition if content is provided
resource "azurerm_role_definition" "custom_role" {
  count       = local.include_custom_role_definition ? 1 : 0
  name        = "${local.policy_prefix}-custom-role"
  scope       = azurerm_management_group.this.id
  description = "Custom role definition for ${var.display_name} management group"
  
  permissions {
    actions          = jsondecode(var.custom_role_definition).permissions.actions
    not_actions      = try(jsondecode(var.custom_role_definition).permissions.not_actions, [])
    data_actions     = try(jsondecode(var.custom_role_definition).permissions.data_actions, [])
    not_data_actions = try(jsondecode(var.custom_role_definition).permissions.not_data_actions, [])
  }
  
  assignable_scopes = [azurerm_management_group.this.id]
}

# Create Azure policy if content is provided
resource "azurerm_policy_definition" "azure_policy" {
  count               = local.include_azure_policy ? 1 : 0
  name                = "${local.policy_prefix}-policy"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "${local.policy_prefix}-policy"
  description         = "Custom policy for ${var.display_name} management group"
  management_group_id = azurerm_management_group.this.id
  
  policy_rule = var.azure_policy
  parameters  = try(jsondecode(var.azure_policy).parameters, null)
}

# Assign Azure policy to the management group
resource "azurerm_management_group_policy_assignment" "azure_policy" {
  count                = local.include_azure_policy ? 1 : 0
  name                 = "${local.policy_prefix}-policy-assignment"
  policy_definition_id = azurerm_policy_definition.azure_policy[count.index].id
  management_group_id  = azurerm_management_group.this.id
  display_name         = "${local.policy_prefix}-policy-assignment"
  description          = "Policy assignment for ${var.display_name} management group"
}