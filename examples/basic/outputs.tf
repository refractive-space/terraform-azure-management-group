output "management_group_id" {
  description = "The ID of the created management group"
  value       = module.basic_mg.id
}

output "display_name" {
  description = "The display name of the management group"
  value       = module.basic_mg.display_name
}