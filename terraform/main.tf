

resource "yandex_compute_disk" "boot-disk" {
  name     = "sda"
  type     = "network-hdd"
  zone     = var.zona-1
  size     = "15"
  image_id = "fd8r4il8eoe5bkl1mhmu"
} 

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "sda-1"
  type     = "network-hdd"
  zone     = var.zona-2
  size     = "15"
  image_id = "fd8r4il8eoe5bkl1mhmu"
} 

resource "yandex_compute_disk" "boot-disk-2" {
  name     = "sda-2"
  type     = "network-hdd"
  zone     = var.zona-3
  size     = "15"
  image_id = "fd87q5833j757gs2omg3"
} 

resource "yandex_compute_disk" "boot-disk-3" {
  name     = "sda-3"
  type     = "network-hdd"
  zone     = var.zona-3
  size     = "15"
  image_id = "fd8r4il8eoe5bkl1mhmu"
} 

resource "yandex_compute_disk" "boot-disk-4" {
  name     = "sda-4"
  type     = "network-hdd"
  zone     = var.zona-3
  size     = "15"
  image_id = "fd8r4il8eoe5bkl1mhmu"
} 
#####################################################################

resource "yandex_compute_instance" "nginx-1" {
  name                      = "linux-vm-1"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = var.zona-1
  

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
    security_group_ids = [yandex_vpc_security_group.group1.id]

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
    security_group_ids = [yandex_vpc_security_group.group1.id]
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
    nat       = var.nat
    security_group_ids = [yandex_vpc_security_group.group1.id]
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

resource "yandex_compute_instance" "Elasticsearch" {
    name                      = "linux-vm-4"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = var.zona-3
  

 resources {

    core_fraction = 5
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-3.id
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-3.id}"
    nat       = true
    security_group_ids = [yandex_vpc_security_group.group1.id]
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

resource "yandex_compute_instance" "Kibana" {
    name                      = "linux-vm-5"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = var.zona-3
  

 resources {

    core_fraction = 5
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-4.id
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-3.id}"
    nat       = var.nat
    security_group_ids = [yandex_vpc_security_group.group1.id]
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

/*
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "test-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  name       = "test-route-table"
  network_id = "${yandex_vpc_network.network-1.id}"
}
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
*/
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


resource "yandex_vpc_security_group" "group1" {
  name        = "My security group"
  description = "description for my security group"
  network_id  = "${yandex_vpc_network.network-1.id}"

  labels = {
    my-label = "my-label-value"
  }

  ingress {
    protocol       = "TCP"
    description    = "rule1 description"
    port           = 80
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  ingress {
    protocol       = "TCP"
    description    = "rule1 description"
    port           = 443
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  ingress {
    protocol       = "ANY"
    description    = "rule1 description"
    port           = 22
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

ingress {
    protocol       = "ANY"
    description    = "rule1 description"
    port           = 9200
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  ingress {
    protocol       = "ANY"
    description    = "rule1 description"
    port           = 5601
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  egress {
    protocol       = "ANY"
    description    = "rule2 description"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  egress {
    protocol       = "UDP"
    description    = "rule3 description"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [ "0.0.0.0/0" ]
  }
}

###########################################################################################

resource "yandex_alb_backend_group" "test-backend-group" {
  name      = "my-backend-group"

  http_backend {
    name = "test-http-backend"
    weight = 1
    port = 80
    target_group_ids = ["${yandex_alb_target_group.foo.id}"]
    tls {
      sni = "backend-domain.internal"
    }
    load_balancing_config {
      panic_threshold = 50
    }    
    healthcheck {
      timeout = "1s"
      interval = "1s"
      http_healthcheck {
        path  = "/"
      }
    }
    http2 = "true"
  }
}

##############################################################################################

resource "yandex_alb_http_router" "tf-router" {
  name          = "tf-router"
  labels        = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name                    = "vhost"
  http_router_id          = yandex_alb_http_router.tf-router.id
  route {
    name                  = "my-route"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.test-backend-group.id
        timeout           = "60s"
      }
    }
  }
}    

#################################################################################################

resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "my-load-balancer"

  network_id  = yandex_vpc_network.network-1.id
  
  allocation_policy {
    location {
      zone_id   = var.zona-3
      subnet_id = yandex_vpc_subnet.subnet-3.id
    }
  }
  
  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
          
        }
      }
      ports = [ 80 ]
    }    
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }
  
  log_options {
    discard_rule {
      #http_code_intervals = "ALL"
      discard_percent = 75
    }
  }
}
