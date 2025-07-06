module "basic_mg" {
  source = "../../"
  
  display_name = "Development Environment"
  
  subscription_ids = [
    "12345678-1234-1234-1234-123456789012"
  ]
}