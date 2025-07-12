module "keyvlt" {
  depends_on        = [module.resource_group]
  source            = "../Child/azure key_vault"
  keyvault_location = "centralindia"
  keyvault_name     = "kknewg3keyvault"
  rg_name           = "kkrg-infra"

}
module "keyscrtuser" {
  depends_on    = [module.keyvlt, module.resource_group]
  source        = "../Child/azure_keysceret"
  secret_name   = "kkazvmname"
  secret_value  = "kkazurevm"
  rg_name       = "kkrg-infra"
  keyvault_name = "kknewg3keyvault"
}

module "keyscrtpwd" {
  depends_on    = [module.keyvlt, module.resource_group,module.keyscrtuser]
  source        = "../Child/azure_keysceret"
  secret_name   = "vmpwd"
  secret_value  = "kkazure@vm123"
  rg_name       = "kkrg-infra"
  keyvault_name = "kknewg3keyvault"
}


module "resource_group" {
  source      = "../Child/azure_resource_group"
  rg_name     = "kkrg-infra"
  rg_location = "centralindia"

}

module "virt_net" {
  depends_on    = [module.resource_group]
  source        = "../Child/azure_virtual_net"
  vnet_name     = "kkvnet-infra"
  vnet_location = "centralindia"
  rg_name       = "kkrg-infra"
  address_space = ["10.0.0.0/16"]

}

module "frontend-subnet" {
  depends_on       = [module.virt_net]
  source           = "../Child/azure_subnet"
  subnet_name      = "frontend-subnet"
  rg_name          = "kkrg-infra"
  vnet_name        = "kkvnet-infra"
  address_prefixes = ["10.0.1.0/24"]
}

module "backend-subnet" {
  depends_on       = [module.virt_net]
  source           = "../Child/azure_subnet"
  subnet_name      = "backend-subnet"
  rg_name          = "kkrg-infra"
  vnet_name        = "kkvnet-infra"
  address_prefixes = ["10.0.2.0/24"]
}

module "pip-front" {
  depends_on        = [module.resource_group]
  source            = "../Child/azure_public ip"
  pip_location      = "centralindia"
  pip_name          = "pipfrontend"
  rg_name           = "kkrg-infra"
  allocation_method = "Static"
}

module "virtual_machine" {
  depends_on      = [module.frontend-subnet, module.pip-front, module.keyscrtuser, module.keyscrtpwd, module.keyvlt]
  source          = "../Child/azure_virtual machine"
  nic_name        = "nic-frontend"
  nic_location    = "centralindia"
  rg_name         = "kkrg-infra"
  vm_name         = "kk-frontend"
  vm_location     = "centralindia"
  vm_size         = "Standard_F2"
  image_offer     = "0001-com-ubuntu-server-focal"
  image_publisher = "Canonical"
  image_sku       = "20_04-lts"
  image_version   = "latest"
  pip_name        = "pipfrontend"
  subnet_name     = "frontend-subnet"
  vnet_name       = "kkvnet-infra"
  secret_username = "kkazvmname"
  secret_userpwd  = "vmpwd"
  keyvault_name   = "kknewg3keyvault"

}


# module "sqlserv" {
#   depends_on                             = [module.resource_group]
#   source                                 = "../Child/azure_sql server"
#   sqlserver_name                         = "kksqlinfra"
#   rg_name                                = "kkrg-infra"
#   sqlserver_location                     = "centralindia"
#   sqlserver_administrator_login          = "kksqlnew"
#   sqlserver_administrator_login_password = "kk123@We"
# }

# module "sqldata" {
#   depends_on      = [module.sqlserv]
#   source          = "../Child/azure_sql database"
#   sqldatabse_name = "kksqldatainfra"
#   rg_name         = "kkrg-infra"
#   sqlserver_name  = "kksqlinfra"

# }