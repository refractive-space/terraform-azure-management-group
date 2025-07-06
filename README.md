# Azure Management Group Terraform Module

[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/your-org/management-group/azurerm)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.8.0-blue.svg)](https://www.terraform.io/)
[![AzureRM Provider](https://img.shields.io/badge/azurerm-%3E%3D3.0-blue.svg)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

A lightweight Terraform module for creating and managing Azure Management Groups with optional custom role definitions and Azure policies.

## Features

- ✅ **Simple Management Group Creation** - Create management groups with minimal configuration
- ✅ **Custom Role Definitions** - Attach custom roles for granular access control
- ✅ **Azure Policies** - Enforce governance and compliance policies
- ✅ **Subscription Association** - Associate subscriptions with management groups
- ✅ **Flexible Naming** - Customizable policy naming with prefix support
- ✅ **Input Validation** - Built-in validation for all inputs
- ✅ **Comprehensive Outputs** - Access all created resource IDs and properties

## Usage

### Basic Example

```hcl
module "development_mg" {
  source = "your-org/management-group/azurerm"
  
  display_name = "Development"
  
  subscription_ids = [
    "12345678-1234-1234-1234-123456789012",
    "87654321-4321-4321-4321-210987654321"
  ]
}
```

### With Custom Role Definition

```hcl
module "restricted_mg" {
  source = "your-org/management-group/azurerm"
  
  display_name                = "Restricted Environment"
  parent_management_group_id  = "parent-mg-id"
  
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
}
```

### With Azure Policy

```hcl
module "compliance_mg" {
  source = "your-org/management-group/azurerm"
  
  display_name               = "Compliance Environment"
  parent_management_group_id = "parent-mg-id"
  
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
}
```

### Complete Example

```hcl
module "production_mg" {
  source = "your-org/management-group/azurerm"
  
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

## Examples

See the [examples](./examples) directory for more comprehensive usage patterns:

- [Basic](./examples/basic) - Simple management group creation
- [With RBAC](./examples/with-rbac) - Management group with custom role definition
- [With Policy](./examples/with-policy) - Management group with Azure policy
- [Complete](./examples/complete) - Full-featured example with all options

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group) | resource |
| [azurerm_role_definition.custom_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_policy_definition.azure_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_management_group_policy_assignment.azure_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the management group to create | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name/ID of the management group to create. If not provided, will use a normalized version of display\_name | `string` | `""` | no |
| <a name="input_parent_management_group_id"></a> [parent\_management\_group\_id](#input\_parent\_management\_group\_id) | The parent management group ID where this management group will be created. If not provided, will be created under the root tenant group | `string` | `""` | no |
| <a name="input_subscription_ids"></a> [subscription\_ids](#input\_subscription\_ids) | List of subscription IDs to associate with this management group | `list(string)` | `[]` | no |
| <a name="input_policy_prefix"></a> [policy\_prefix](#input\_policy\_prefix) | Optional prefix for policy names. If empty, only the normalized management group name will be used | `string` | `""` | no |
| <a name="input_custom_role_definition"></a> [custom\_role\_definition](#input\_custom\_role\_definition) | JSON content for the custom role definition. If empty, no custom role will be created | `string` | `""` | no |
| <a name="input_azure_policy"></a> [azure\_policy](#input\_azure\_policy) | JSON content for the Azure policy. If empty, no policy will be created | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the management group |
| <a name="output_name"></a> [name](#output\_name) | The name of the management group |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | The display name of the management group |
| <a name="output_policy_prefix"></a> [policy\_prefix](#output\_policy\_prefix) | The computed policy prefix used for naming policies |
| <a name="output_custom_role_definition_id"></a> [custom\_role\_definition\_id](#output\_custom\_role\_definition\_id) | The ID of the custom role definition, if created |
| <a name="output_azure_policy_definition_id"></a> [azure\_policy\_definition\_id](#output\_azure\_policy\_definition\_id) | The ID of the Azure policy definition, if created |
| <a name="output_azure_policy_assignment_id"></a> [azure\_policy\_assignment\_id](#output\_azure\_policy\_assignment\_id) | The ID of the Azure policy assignment, if created |
| <a name="output_subscription_ids"></a> [subscription\_ids](#output\_subscription\_ids) | The list of subscription IDs associated with this management group |

## Prerequisites

Before using this module, ensure you have:

1. **Azure subscription** with appropriate permissions
2. **Management Groups enabled** in your Azure AD tenant
3. **Appropriate Azure RBAC permissions** for Management Groups operations:
   - `Microsoft.Management/managementGroups/read`
   - `Microsoft.Management/managementGroups/write`
   - `Microsoft.Management/managementGroups/subscriptions/write`
   - `Microsoft.Authorization/roleDefinitions/write` (if using custom roles)
   - `Microsoft.Authorization/policyDefinitions/write` (if using policies)
4. **AzureRM provider configured** with appropriate authentication

## Input Validation

This module includes comprehensive input validation:

- **Display Name**: Must be 1-90 characters
- **Name**: Must contain only alphanumeric characters, hyphens, underscores, periods, and parentheses
- **Parent Management Group ID**: Must be a valid management group ID format
- **Subscription IDs**: Must be valid UUIDs
- **Policy Content**: Must be valid JSON or empty string
- **Role Definition**: Must be valid JSON or empty string

## Policy Naming

Policies and roles are automatically named using the following convention:
- Custom Role Definition: `{policy_prefix}-{normalized_mg_name}-custom-role`
- Azure Policy Definition: `{policy_prefix}-{normalized_mg_name}-policy`
- Azure Policy Assignment: `{policy_prefix}-{normalized_mg_name}-policy-assignment`

Where:
- `policy_prefix` is optional and defaults to empty
- `normalized_mg_name` is the display name converted to lowercase with spaces replaced by hyphens

## Common Use Cases

### 1. Environment Separation
Create separate management groups for different environments (dev, staging, prod) with appropriate governance.

### 2. Business Unit Organization
Organize subscriptions by business units or departments with specific policies and roles.

### 3. Compliance Management
Implement governance policies and custom roles to meet regulatory requirements.

### 4. Resource Management
Control resource deployment and configuration across multiple subscriptions.

## Contributing

Contributions are welcome! Please read the contributing guidelines and submit pull requests to the main branch.

## License

This module is licensed under the **Apache License 2.0**, which means you can:

- ✅ **Use it freely** for any purpose (commercial or non-commercial)
- ✅ **Modify and distribute** your changes
- ✅ **Include it in proprietary software** without restriction
- ✅ **Use it forever** without worrying about license changes

The Apache License 2.0 is one of the most permissive open-source licenses, ensuring this module will always remain free and available for everyone. See [LICENSE](LICENSE) for the full license text.

## Support

For issues and questions:
- Check the [examples](./examples) directory
- Review the [Terraform AzureRM Management Group documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group)
- Open an issue in this repository