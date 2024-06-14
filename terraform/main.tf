

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
  type     = "network-ssd"
  zone     = var.zona-3
  size     = "15"
  image_id = "fd8r4il8eoe5bkl1mhmu"
} 

resource "yandex_compute_disk" "boot-disk-5" {
  name     = "sda-5"
  type     = "network-hdd"
  zone     = var.zona-3
  size     = "15"
  image_id = "fd8r4il8eoe5bkl1mhmu"
} 

##########################################################################################


resource "yandex_vpc_security_group" "group-1" {
  name        = "My security group-1"
  description = "description for my security group-2"
  network_id  = "${yandex_vpc_network.network-1.id}"


  

  ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  ingress {
    protocol       = "ANY"
    from_port      = 10050
    to_port        = 10051
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [ "0.0.0.0/0" ]
  }
}

############################################################################################

resource "yandex_compute_instance" "bastion-host" {
  name                      = "linux-vm-0"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = var.zona-3
  

 resources {

    core_fraction = 5
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-5.id
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-3.id}"
    nat       = true
    security_group_ids = [yandex_vpc_security_group.group-1.id]
    ip_address = "192.168.12.254"

  }

  metadata = {
    #ssh-keys = ""
  user-data = file(var.yaml)
  }

  scheduling_policy {
    preemptible = true
  }
}


#################################################################################

resource "yandex_compute_snapshot_schedule" "default" {
  name = "snapshot"

  schedule_policy {
    expression =  "0 0 ? * *"
  }

  snapshot_count = 2

  
  disk_ids = [ yandex_compute_disk.boot-disk.id, yandex_compute_disk.boot-disk-1.id, yandex_compute_disk.boot-disk-2.id, yandex_compute_disk.boot-disk-3.id, yandex_compute_disk.boot-disk-4.id ]
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
    nat       = var.nat
    security_group_ids = [yandex_vpc_security_group.web.id]

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
    nat       = var.nat
    security_group_ids = [yandex_vpc_security_group.web.id]
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
    security_group_ids = [yandex_vpc_security_group.zabbix.id]
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
    nat       = var.nat
    security_group_ids = [yandex_vpc_security_group.elasticsearch.id]
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
    security_group_ids = [yandex_vpc_security_group.kibana.id]
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


resource "yandex_vpc_security_group" "web" {
  name        = "My security group Web"
  description = "description for my security group"
  network_id  = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol       = "ANY"
    port           = 80
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  ingress {
    protocol       = "ANY"
    port           = 443
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = [  "192.168.12.254/32" ]
  }

  ingress {
    protocol       = "ANY"
    from_port      = 10050
    to_port        = 10051
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [ "0.0.0.0/0" ]
  }
}

##################

resource "yandex_vpc_security_group" "elasticsearch" {
  name        = "My security group Elasticsearch"
  description = "description for my security group"
  network_id  = "${yandex_vpc_network.network-1.id}"
 
ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = [  "192.168.12.254/32" ]
  }

ingress {
    protocol       = "tcp"
    port           = 9200
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

ingress {
    protocol       = "tcp"
    port           = 9300
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

ingress {
    protocol       = "ANY"
    from_port      = 10050
    to_port        = 10051
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

 
egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

}

###########

resource "yandex_vpc_security_group" "kibana" {
  name        = "My security group Kibana"
  description = "description for my security group"
  network_id  = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = [  "192.168.12.254/32" ]
  }

 ingress {
    protocol       = "tcp"
    port           = 5601
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

  ingress {
    protocol       = "ANY"
    from_port      = 10050
    to_port        = 10051
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }
 
  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

}

###########################

resource "yandex_vpc_security_group" "zabbix" {
  name        = "My security group Zabbix"
  description = "description for my security group"
  network_id  = "${yandex_vpc_network.network-1.id}"
 
 ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = [  "192.168.12.254/32" ]
  }
 ingress {
    protocol       = "ANY"
    port           = 80
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

 ingress {
    protocol       = "ANY"
    port           = 443
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }
 ingress {
    protocol       = "ANY"
    from_port      = 10050
    to_port        = 10051
    v4_cidr_blocks = [  "0.0.0.0/0" ]
  }

 
  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [  "0.0.0.0/0" ]
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
    #tls {
     # sni = "backend-domain.internal"
   # }
    load_balancing_config {
      panic_threshold = 80
    }    
    healthcheck {
      timeout = "10s"
      interval = "2s"
      healthy_threshold = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path  = "/"
      }
    }
    http2 = "false"
  }
}

##############################################################################################

resource "yandex_alb_http_router" "tf-router" {
  name          = "tf-router"
  labels        = {
    tf-label    = "tf-label-value"
    empty-label = "s"
    
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
        timeout           = "30s"
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
      zone_id   =  var.zona-3
      subnet_id = "${yandex_vpc_subnet.subnet-3.id}"
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
      
      discard_percent = 75
    }
  }
}

