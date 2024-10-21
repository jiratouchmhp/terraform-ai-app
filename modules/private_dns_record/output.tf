# Output for A Record FQDN
output "a_record_fqdn" {
  description = "The FQDN of the private DNS A record"
  value       = azurerm_private_dns_a_record.a_record[*].fqdn
}

# Output for CNAME Record FQDN
output "cname_record_fqdn" {
  description = "The FQDN of the private DNS CNAME record"
  value       = azurerm_private_dns_cname_record.cname_record[*].fqdn
}
