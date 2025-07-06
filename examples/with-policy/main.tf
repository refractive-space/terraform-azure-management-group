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