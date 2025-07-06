output "management_group_id" {
  description = "The ID of the created management group"
  value       = module.complete_mg.id
}

output "custom_role_definition_id" {
  description = "The ID of the custom role definition"
  value       = module.complete_mg.custom_role_definition_id
}

output "azure_policy_definition_id" {
  description = "The ID of the Azure policy definition"
  value       = module.complete_mg.azure_policy_definition_id
}

output "azure_policy_assignment_id" {
  description = "The ID of the Azure policy assignment"
  value       = module.complete_mg.azure_policy_assignment_id
}