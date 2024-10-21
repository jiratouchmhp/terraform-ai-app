resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                       = "${var.resource_name}-diagnostic"
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Log Categories
  dynamic "enabled_log" {
    for_each = var.logs_categories
    content {
      category = enabled_log.value
    }
  }
  # Log Categories
  dynamic "enabled_log" {
    for_each = var.logs_categories_group
    content {
      category_group  = enabled_log.value
    }
  }

  # Metric Categories
  dynamic "metric" {
    for_each = var.metrics_categories
    content {
      category = metric.value
      enabled  = true
    }
  }
}
