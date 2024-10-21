# modules/usergroups/outputs.tf

output "owner_group_id" {
  description = "ID of the Owner group"
  value       = azuread_group.owner_group.object_id
}

output "operator_group_id" {
  description = "ID of the Operator group"
  value       = azuread_group.operator_group.object_id
}

output "readonly_group_id" {
  description = "ID of the Read-only group"
  value       = azuread_group.readonly_group.object_id
}
