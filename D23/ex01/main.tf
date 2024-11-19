provider "azurerm"{
    features{}
    subscription_id="4cad2eb7-c985-4082-87bd-3eaf873644fa"
}
resource "azurerm_resource_group" "rg01"{
    location = " East US"
    name = "rg01"
    tags = {
        env = "dev"
        dep = "finance"
        owner = "sathviksp"
        proj = "p1"
    }
}
resource "azurerm_virtual_network" "vnet01"{
    location = azurerm_resource_group.rg01.location
    resource_group_name = azurerm_resource_group.rg01.name
    name = "Vnet01"
    address_space = ["10.20.0.0/16"]
    subnet {
    name             = "subnet1"
    address_prefixes = ["10.20.1.0/24"]
  }

  subnet {
    name             = "subnet2"
    address_prefixes = ["10.20.2.0/24"]
  }
    tags = {
        env = "dev"
        dep = "finance"
        owner = "sathvik"
        proj = "p1"
    }
}
