# Create a resource group
resource "azurerm_resource_group" playground_resources {
  name     = "${var.cluster_name}-resources"
  location = var.location
}

# Create VNet and Subnets
resource "azurerm_virtual_network" "aks_vnet" {
  resource_group_name = azurerm_resource_group.playground_resources.name
  location            = azurerm_resource_group.playground_resources.location
  name                = var.virtual_network_name
  address_space       = ["10.50.0.0/16"]
}

resource "azurerm_subnet" "defaultSubnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.playground_resources.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.50.0.0/24"]
}

# AGIC Subnet, see https://docs.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-existing
resource "azurerm_subnet" "agicSubnet" {
  name                 = "agicSubnet"
  resource_group_name  = azurerm_resource_group.playground_resources.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.50.20.0/24"]
}

# ASK Subnet
resource "azurerm_subnet" "askSubnet" {
  name                 = "aksSubnet"
  resource_group_name  = azurerm_resource_group.playground_resources.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.50.24.0/22"]
}

resource "azurerm_kubernetes_cluster" "playground_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.playground_resources.location
  resource_group_name = azurerm_resource_group.playground_resources.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    vnet_subnet_id = azurerm_subnet.askSubnet.id
  }
  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = var.ssh_public_key
    }
  }
  
  network_profile {
    network_plugin     = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    ingress_application_gateway {
      enabled = var.ingress_application_gateway_enabled
      subnet_id = azurerm_subnet.agicSubnet.id
    }
  }

  tags = {
    Environment = "playground"
  }

  depends_on = [
    azurerm_subnet.askSubnet,
    azurerm_subnet.agicSubnet
  ]
}

#resource "azurerm_kubernetes_cluster_node_pool" "playground_spot" {
#  name                  = "spot"
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.playground_cluster.id
#  vm_size               = var.vm_size
#  node_count            = var.node_count
#  priority              = var.priority
#  eviction_policy       = var.eviction_policy
#  spot_max_price        = var.spot_max_price
#  node_labels = {
#    "kubernetes.azure.com/scalesetpriority" = "spot"
#  }
#  node_taints = [
#    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
#  ]
#}