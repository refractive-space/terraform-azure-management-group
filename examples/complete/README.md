# Complete Management Group Example

This example demonstrates all features of the Azure Management Group module including custom role definitions and Azure policies.

## Usage

```hcl
module "complete_mg" {
  source = "../../"
  
  display_name               = "Production Environment"
  name                       = "prod-mg"
  parent_management_group_id = "parent-mg-id"
  policy_prefix              = "prod"
  
  subscription_ids = [
    "12345678-1234-1234-1234-123456789012",
    "87654321-4321-4321-4321-210987654321"
  ]
  
  custom_role_definition = jsonencode({
    permissions = {
      actions = [
        "Microsoft.Resources/subscriptions/resourceGroups/read",
        "Microsoft.Resources/subscriptions/resourceGroups/write",
        "Microsoft.Storage/storageAccounts/read",
        "Microsoft.Storage/storageAccounts/write"
      ]
      not_actions = [
        "Microsoft.Resources/subscriptions/resourceGroups/delete",
        "Microsoft.Storage/storageAccounts/delete"
      ]
      data_actions = []
      not_data_actions = []
    }
  })
  
  azure_policy = jsonencode({
    if = {
      allOf = [
        {
          field = "type"
          equals = "Microsoft.Storage/storageAccounts"
        },
        {
          field = "Microsoft.Storage/storageAccounts/encryption.services.blob.enabled"
          equals = "false"
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}
```

## What This Example Creates

- A management group named "Production Environment" with ID "prod-mg"
- Associates multiple subscriptions with the management group
- Creates a custom role definition with specific permissions
- Creates and assigns an Azure policy to enforce storage encryption
- Uses a policy prefix for consistent naming

## Variables

- `display_name`: The display name for the management group
- `name`: The ID for the management group
- `parent_management_group_id`: The parent management group ID
- `policy_prefix`: Prefix for policy and role names
- `subscription_ids`: List of subscription IDs to associate
- `custom_role_definition`: JSON definition for custom role
- `azure_policy`: JSON definition for Azure policy

## Outputs

- `management_group_id`: The ID of the created management group
- `custom_role_definition_id`: The ID of the custom role definition
- `azure_policy_definition_id`: The ID of the Azure policy definition
- `azure_policy_assignment_id`: The ID of the Azure policy assignment