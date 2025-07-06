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