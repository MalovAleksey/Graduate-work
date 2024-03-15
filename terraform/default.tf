
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  folder_id = "b1g8ju82h88t8bmqcvhi"
  cloud_id = "b1g8d8488ltbllul6nhd"
}

provider "yandex" {
token                     = var.token
cloud_id                  = local.cloud_id
folder_id                 = local.folder_id 
#service_account_key_file  = var.key
}