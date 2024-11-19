provider "azurerm" {
  features {}
  subscription_id = "4cad2eb7-c985-4082-87bd-3eaf873644fa"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-S2"
  location = "Canada Central"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-S2"
  address_space       = ["192.168.0.0/19"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnets
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/25"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.128/25"]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.0/25"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-S2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Network Interface for Linux VM
resource "azurerm_network_interface" "nic_linux" {
  name                = "nic-linux-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "ipconfig-linux"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Network Interface for Windows VM
resource "azurerm_network_interface" "nic_windows" {
  name                = "nic-windows-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "ipconfig-windows"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = "linux-vm"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "Password@123"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic_linux.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "solvedevops1643693563360"
    offer     = "rocky-linux-9"
    sku       = "plan001"
    version   = "latest"
  }

  plan {
    name      = "plan001"
    publisher = "solvedevops1643693563360"
    product   = "rocky-linux-9"
  }
}

#disk1 for linux-vm
resource "azurerm_managed_disk" "data_disk1" {
  name                 = "linux-vm-disk"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 2
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk1_attachment" {
  managed_disk_id    = azurerm_managed_disk.data_disk1.id
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm.id
  lun                = 0
  caching            = "ReadWrite"
}


# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                = "windows-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DC1s_v3"
  admin_username      = "adminuser"
  admin_password      = "Password@123!" # Replace with a secure password

  network_interface_ids = [azurerm_network_interface.nic_windows.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-24h2-pro"
    version   = "latest"
  }
}

#disk2 for win-vm
resource "azurerm_managed_disk" "data_disk2" {
  name                 = "win-vm-disk"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 2
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk2_attachment" {
  managed_disk_id    = azurerm_managed_disk.data_disk2.id
  virtual_machine_id = azurerm_windows_virtual_machine.windows_vm.id
  lun                = 0
  caching            = "ReadWrite"
}
