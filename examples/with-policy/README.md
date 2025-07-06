# Management Group with Policy Example

This example demonstrates how to create a management group with Azure policies for governance and compliance.

## Usage

```hcl
module "policy_mg" {
  source = "../../"
  
  display_name = "Compliance Environment"
  
  azure_policy = jsonencode({
    if = {
      allOf = [
        {
          field = "type"
          equals = "Microsoft.Storage/storageAccounts"
        }
      ]
    }
    then = {
      effect = "audit"
      details = {
        type = "Microsoft.Storage/storageAccounts"
        name = "auditStorageAccounts"
      }
    }
  })
  
  subscription_ids = [
    "12345678-1234-1234-1234-123456789012"
  ]
}
```

## What This Example Creates

- A management group named "Compliance Environment"
- An Azure policy that audits storage accounts
- A policy assignment that applies the policy to the management group
- Associates the specified subscription with the management group

## Policy Details

The Azure policy:
- Targets all storage accounts (`Microsoft.Storage/storageAccounts`)
- Uses the `audit` effect to log compliance status
- Applies to all resources within the management group scope

## Variables

- `display_name`: The display name for the management group
- `azure_policy`: JSON definition for the Azure policy
- `subscription_ids`: List of subscription IDs to associate

## Outputs

- `management_group_id`: The ID of the created management group
- `azure_policy_definition_id`: The ID of the Azure policy definition
- `azure_policy_assignment_id`: The ID of the Azure policy assignment