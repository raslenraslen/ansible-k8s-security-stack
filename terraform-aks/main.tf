terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-raslen-cert"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "raslen-cert-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "raslen-cert"

  default_node_pool {
    name               = "nodepool"
    node_count         = 2
    vm_size            = "Standard_B2ms"
    os_disk_size_gb    = 30
  }

  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Env = "Dev"
  }
}
