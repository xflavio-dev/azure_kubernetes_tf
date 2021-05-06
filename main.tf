terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-xf4" {
  name     = "rg-xf4"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "k8s-xf4-kuber-cluster" {
  name = "k8s-xf4-kuber-cluster"
  location = azurerm_resource_group.rg-xf4.location
  resource_group_name = azurerm_resource_group.rg-xf4.name
  dns_prefix          = "k8s-xf4-kuber-cluster"

  default_node_pool {
    name = "default"
    node_count = 3
    vm_size = "Standard_DS2_v2"
  }

  tags = {
    Environment = "Production"
  }

  identity {
    type = "SystemAssigned"
  }

}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s-xf4-kuber-cluster.kube_config_raw
  sensitive = true
}

resource "local_file" "kube_config" {
    content     = azurerm_kubernetes_cluster.k8s-xf4-kuber-cluster.kube_config_raw
    filename = "C:\\Users\\xfl4v10\\.kube\\config"
}
