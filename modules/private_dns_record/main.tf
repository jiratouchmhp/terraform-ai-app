resource "azurerm_private_dns_a_record" "a_record" {
  count               = length(var.records)
  name                = var.records[count.index].name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = [var.records[count.index].ip]
}

resource "azurerm_private_dns_cname_record" "cname_record" {
  count               = length(var.cname_records)
  name                = var.cname_records[count.index].name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = var.cname_records[count.index].cname
}
