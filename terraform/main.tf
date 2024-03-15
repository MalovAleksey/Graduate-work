terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
token = var.token
cloud_id = "b1g8d8488ltbllul6nhd"
folder_id = "b1g8ju82h88t8bmqcvhi" 
}

resource "yandex_compute_disk" "boot-disk" {
  name     = "sda"
  type     = "network-hdd"
  zone     = var.zona
  size     = "20"
  image_id = "fd88r89var8ukrlbmaki"
} 

resource "yandex_compute_instance" "vm-1" {
  name                      = "linux-vm"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = var.zona

 resources {

    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    #ssh-keys = ""
  user-data = file(var.yaml)
  }

  scheduling_policy {
    preemptible = true
  }
}

 resource "yandex_vpc_network" "network-1" {
  name = "network1"
 }


 resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.zona
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id = "${yandex_vpc_network.network-1.id}"
}

#####################################################################################

