provider "azurerm"{
    features{}
    subscription_id="b49488bb-d890-476e-9714-4259ca95a60b"
}
resource "azurerm_resource_group" "rg01"{
    location = var.location
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
    address_space = [var.rg_location[var.location]]

    tags = {
        env = var.tag.env
        dep = var.tag.dep
        owner = var.tag.owner
        proj = var.tag.proj
    }   
}

resource "azurerm_subnet" "subnet" {
    for_each = var.subnet
    name = each.key
    address_prefixes = [each.value]
     virtual_network_name = azurerm_virtual_network.vnet01.name
  resource_group_name = azurerm_resource_group.rg01.name
}
