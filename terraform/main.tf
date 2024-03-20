

resource "yandex_compute_disk" "boot-disk" {
  name     = "sda"
  type     = "network-hdd"
  zone     = var.zona-1
  size     = "15"
  image_id = "fd88r89var8ukrlbmaki"
} 

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "sda-1"
  type     = "network-hdd"
  zone     = var.zona-2
  size     = "15"
  image_id = "fd88r89var8ukrlbmaki"
} 

resource "yandex_compute_disk" "boot-disk-2" {
  name     = "sda-2"
  type     = "network-hdd"
  zone     = var.zona-3
  size     = "15"
  image_id = "fd88r89var8ukrlbmaki"
} 

#####################################################################

resource "yandex_compute_instance" "nginx-1" {
  name                      = "linux-vm-1"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = var.zona-1
  #user_data                 = file(var.skript_enginx)

 resources {

    core_fraction = 5
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


###########################################################################

 
resource "yandex_compute_instance" "nginx-2" {
    name                      = "linux-vm-2"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = var.zona-2
  #user_data                 = file(var.skript_enginx)

 resources {

    core_fraction = 5
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-2.id}"
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

 


############################################################################################

resource "yandex_compute_instance" "zabbix" {
    name                      = "linux-vm-3"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = var.zona-3
  

 resources {

    core_fraction = 5
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-2.id
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-3.id}"
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

#############################################################################################

resource "yandex_vpc_network" "network-1" {
  name = "network1"
 }

 resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.zona-1
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id = "${yandex_vpc_network.network-1.id}"
 }

  resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = var.zona-2
  v4_cidr_blocks = ["192.168.11.0/24"]
  network_id = "${yandex_vpc_network.network-1.id}"
}

resource "yandex_vpc_subnet" "subnet-3" {
  name           = "subnet3"
  zone           = var.zona-3
  v4_cidr_blocks = ["192.168.12.0/24"]
  network_id = "${yandex_vpc_network.network-1.id}"
}

#######################################################################################################

resource "yandex_alb_target_group" "foo" {
    name         = "homework"

  target {
    subnet_id    = "${yandex_vpc_subnet.subnet-1.id}"
    ip_address   = "${yandex_compute_instance.nginx-1.network_interface.0.ip_address}"
  }

  target {
    subnet_id    = "${yandex_vpc_subnet.subnet-2.id}"
    ip_address   = "${yandex_compute_instance.nginx-2.network_interface.0.ip_address}"
  }
  
}

#######################################################################################################
