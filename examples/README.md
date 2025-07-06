# Azure Management Group Module Examples

This directory contains various examples demonstrating how to use the Azure Management Group Terraform module.

## Available Examples

### [Basic](./basic)
Simple management group creation with minimal configuration.

### [Complete](./complete)
Full-featured example showcasing all module capabilities including custom roles and policies.

### [With RBAC](./with-rbac)
Management group with custom role definitions for granular access control.

### [With Policy](./with-policy)
Management group with Azure policies for governance and compliance.

## How to Use Examples

1. Navigate to the desired example directory
2. Review the `README.md` file for specific instructions
3. Copy the example code to your own Terraform configuration
4. Modify the variables to match your requirements
5. Run `terraform init`, `terraform plan`, and `terraform apply`

## Prerequisites

Before running any examples, ensure you have:

- Azure CLI installed and authenticated
- Terraform >= 1.8.0 installed
- Appropriate Azure permissions for Management Groups operations
- AzureRM provider configured