terraform {
  backend "azurerm" {
    resource_group_name  = "DefaultResourceGroup-CQ"
    storage_account_name = "soatchallengestate"
    container_name       = "tfstate"
    key                  = "soat.challenge.k8s.terraform.tfstate"
  }
}