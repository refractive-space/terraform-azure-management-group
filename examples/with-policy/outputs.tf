output "management_group_id" {
  description = "The ID of the created management group"
  value       = module.policy_mg.id
}

output "azure_policy_definition_id" {
  description = "The ID of the Azure policy definition"
  value       = module.policy_mg.azure_policy_definition_id
}

output "azure_policy_assignment_id" {
  description = "The ID of the Azure policy assignment"
  value       = module.policy_mg.azure_policy_assignment_id
}