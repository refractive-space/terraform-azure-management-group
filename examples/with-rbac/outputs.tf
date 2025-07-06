output "management_group_id" {
  description = "The ID of the created management group"
  value       = module.rbac_mg.id
}

output "custom_role_definition_id" {
  description = "The ID of the custom role definition"
  value       = module.rbac_mg.custom_role_definition_id
}