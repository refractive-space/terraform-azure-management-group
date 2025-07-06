# Basic Management Group Example

This example demonstrates the simplest way to create an Azure Management Group using the module.

## Usage

```hcl
module "basic_mg" {
  source = "../../"
  
  display_name = "Development Environment"
  
  subscription_ids = [
    "12345678-1234-1234-1234-123456789012"
  ]
}
```

## What This Example Creates

- A management group named "Development Environment"
- Associates the specified subscription with the management group
- Creates the management group at the root level (no parent specified)

## Variables

- `display_name`: The display name for the management group
- `subscription_ids`: List of subscription IDs to associate with the management group

## Outputs

- `management_group_id`: The ID of the created management group
- `display_name`: The display name of the management group