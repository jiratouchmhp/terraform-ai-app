output "vm_ids" {
  description = "List of Virtual Machine IDs"
  value       = azurerm_linux_virtual_machine.vm[*].id
}

output "vm_names" {
  description = "List of Virtual Machine names"
  value       = azurerm_linux_virtual_machine.vm[*].name
}

output "vm_identity_ids" {
  description = "List of Virtual Machine Managed Identity IDs"
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.identity[0].principal_id if vm.identity != []]
}
