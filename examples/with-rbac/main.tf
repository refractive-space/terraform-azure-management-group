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