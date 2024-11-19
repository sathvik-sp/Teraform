provider "azurerm"{
    features{}
    subscription_id="b49488bb-d890-476e-9714-4259ca95a60b"
}
resource "azurerm_resource_group" "rg01"{
    location = var.rg_location
    name = var.rg_name
    tags = {
        env = var.tag.env
        dep = var.tag.dep
        owner = var.tag.owner
        proj = var.tag.proj
    }
}
resource "azurerm_virtual_network" "vnet01"{
    location = azurerm_resource_group.rg01.location
    resource_group_name = azurerm_resource_group.rg01.name
    name = var.Vnet_name
    address_space = var.address_space
    subnet {
    name             = var.subnet[0]
    address_prefixes = var.address_prefixes[0]
  }

  subnet {
    name             = var.subnet[1]
    address_prefixes = var.address_prefixes[1]
  }
    tags = {
        env = var.tag.env
        dep = var.tag.dep
        owner = var.tag.owner
        proj = var.tag.proj
    }
}
