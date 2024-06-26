resource "azurerm_monitor_autoscale_setting" "web_vmss_autoscale" {
  location            = azurerm_resource_group.rg.location
  name                = "${local.resource_name_prefix}-web-vmss-autoscale-profiles"
  resource_group_name = azurerm_resource_group.rg.name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.web_vmss.id
  profile {
    name = "default"
    capacity {
      default = 2
      maximum = 6
      minimum = 2
    }
    rule {
      scale_action {
        cooldown  = "PT5M"
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
      }
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        operator           = "GreaterThan"
        statistic          = "Average"
        threshold          = 75
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }
    }
    rule {
      scale_action {
        cooldown  = "PT5M"
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
      }
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        operator           = "LessThan"
        statistic          = "Average"
        threshold          = 25
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }
    }
    rule {
      scale_action {
        cooldown  = "PT5M"
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
      }
      metric_trigger {
        metric_name        = "Available Memory Bytes"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        operator           = "GreaterThan"
        statistic          = "Average"
        threshold          = 1073741824
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }
    }
    rule {
      scale_action {
        cooldown  = "PT5M"
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
      }
      metric_trigger {
        metric_name        = "Available Memory Bytes"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
        operator           = "LessThan"
        statistic          = "Average"
        threshold          = 2147483648
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }
    }
  }
}

