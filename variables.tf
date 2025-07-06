# The display name of the management group
variable "display_name" {
  description = "The display name of the management group to create"
  type        = string
  
  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 90
    error_message = "Management group display name must be between 1 and 90 characters."
  }
}

# The name/ID of the management group
variable "name" {
  description = "The name/ID of the management group to create. If not provided, will use a normalized version of display_name"
  type        = string
  default     = ""
  
  validation {
    condition     = var.name == "" || can(regex("^[a-zA-Z0-9-_\\.\\(\\)]+$", var.name))
    error_message = "Management group name must contain only alphanumeric characters, hyphens, underscores, periods, and parentheses."
  }
}

# The parent management group ID where this management group will be created
variable "parent_management_group_id" {
  description = "The parent management group ID where this management group will be created. If not provided, will be created under the root tenant group"
  type        = string
  default     = ""
  
  validation {
    condition     = var.parent_management_group_id == "" || can(regex("^[a-zA-Z0-9-_\\.\\(\\)]+$", var.parent_management_group_id))
    error_message = "Parent management group ID must contain only alphanumeric characters, hyphens, underscores, periods, and parentheses."
  }
}

# Optional list of subscription IDs to associate with this management group
variable "subscription_ids" {
  description = "List of subscription IDs to associate with this management group"
  type        = list(string)
  default     = []
  
  validation {
    condition = alltrue([
      for id in var.subscription_ids : can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", id))
    ])
    error_message = "All subscription IDs must be valid UUIDs."
  }
}

# Optional prefix for policy names to ensure uniqueness
variable "policy_prefix" {
  description = "Optional prefix for policy names. If empty, only the normalized management group name will be used"
  type        = string
  default     = ""
}

# JSON content for custom role definition
variable "custom_role_definition" {
  description = "JSON content for the custom role definition. If empty, no custom role will be created"
  type        = string
  default     = ""
  
  validation {
    condition     = var.custom_role_definition == "" || can(jsondecode(var.custom_role_definition))
    error_message = "Custom role definition must be valid JSON or empty string."
  }
}

# JSON content for Azure policy
variable "azure_policy" {
  description = "JSON content for the Azure policy. If empty, no policy will be created"
  type        = string
  default     = ""
  
  validation {
    condition     = var.azure_policy == "" || can(jsondecode(var.azure_policy))
    error_message = "Azure policy must be valid JSON or empty string."
  }
}