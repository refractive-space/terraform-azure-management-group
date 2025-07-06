# Management Group with RBAC Example

This example demonstrates how to create a management group with custom role definitions for granular access control.

## Usage

```hcl
module "rbac_mg" {
  source = "../../"
  
  display_name = "Development Environment"
  
  custom_role_definition = jsonencode({
    permissions = {
      actions = [
        "Microsoft.Resources/subscriptions/resourceGroups/read",
        "Microsoft.Resources/subscriptions/resourceGroups/write",
        "Microsoft.Storage/storageAccounts/read"
      ]
      not_actions = [
        "Microsoft.Resources/subscriptions/resourceGroups/delete"
      ]
      data_actions = []
      not_data_actions = []
    }
  })
  
  subscription_ids = [
    "12345678-1234-1234-1234-123456789012"
  ]
}
```

## What This Example Creates

- A management group named "Development Environment"
- A custom role definition with specific permissions for development scenarios
- Associates the specified subscription with the management group

## Custom Role Permissions

The custom role allows:
- Reading and writing resource groups
- Reading storage accounts

But denies:
- Deleting resource groups

## Variables

- `display_name`: The display name for the management group
- `custom_role_definition`: JSON definition for the custom role
- `subscription_ids`: List of subscription IDs to associate

## Outputs

- `management_group_id`: The ID of the created management group
- `custom_role_definition_id`: The ID of the custom role definition