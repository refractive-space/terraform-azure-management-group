# The ID of the created management group
output "id" {
  description = "The ID of the management group"
  value       = azurerm_management_group.this.id
}

# The name of the management group
output "name" {
  description = "The name of the management group"
  value       = azurerm_management_group.this.name
}

# The display name of the management group
output "display_name" {
  description = "The display name of the management group"
  value       = azurerm_management_group.this.display_name
}

# The computed policy prefix used for naming policies
output "policy_prefix" {
  description = "The computed policy prefix used for naming policies"
  value       = local.policy_prefix
}

# The ID of the custom role definition (if created)
output "custom_role_definition_id" {
  description = "The ID of the custom role definition, if created"
  value       = local.include_custom_role_definition ? azurerm_role_definition.custom_role[0].id : null
}

# The ID of the Azure policy definition (if created)
output "azure_policy_definition_id" {
  description = "The ID of the Azure policy definition, if created"
  value       = local.include_azure_policy ? azurerm_policy_definition.azure_policy[0].id : null
}

# The ID of the Azure policy assignment (if created)
output "azure_policy_assignment_id" {
  description = "The ID of the Azure policy assignment, if created"
  value       = local.include_azure_policy ? azurerm_management_group_policy_assignment.azure_policy[0].id : null
}

# The list of subscription IDs associated with this management group
output "subscription_ids" {
  description = "The list of subscription IDs associated with this management group"
  value       = azurerm_management_group.this.subscription_ids
}