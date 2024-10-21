resource "azurerm_virtual_machine_extension" "oms_agent" {
  name                 = "${var.vm_name}-oms"
  virtual_machine_id   = var.vm_id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "OmsAgentForLinux"
  type_handler_version = "1.19"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
  {
      "workspaceId": "${var.workspace_id}"
  }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
      "workspaceKey": "${var.workspace_key}"
  }
  PROTECTED_SETTINGS
}
