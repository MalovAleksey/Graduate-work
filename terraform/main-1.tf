variable "zones" {
  description = "List of zones"
  type        = list(string)
  default     = ["zona-1", "zona-2", "zona-3"]
}

variable "disk_image_ids" {
  description = "List of disk image IDs"
  type        = list(string)
  default     = ["fd8r4il8eoe5bkl1mhmu", "fd87q5833j757gs2omg3"]
}

variable "nat" {
  description = "Enable NAT"
  type        = bool
  default     = true
}

variable "yaml" {
  description = "Path to user data file"
  type        = string
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet" {
  for_each      = toset(var.zones)
  name          = "subnet-${each.key}"
  zone          = each.key
  v4_cidr_blocks = ["192.168.${count.index + 10}.0/24"]
  network_id    = yandex_vpc_network.network-1.id
}

resource "yandex_vpc_security_group" "group1" {
  name        = "My security group"
  description = "description for my security group"
  network_id  = yandex_vpc_network.network-1.id

  labels = {
    my-label = "my-label-value"
  }

  ingress {
    protocol       = "TCP"
    description    = "rule1 description"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "rule1 description"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    description    = "rule1 description"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    description    = "rule1 description"
    port           = 9200
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    description    = "rule1 description"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "rule2 description"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "UDP"
    description    = "rule3 description"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_disk" "boot_disk" {
  for_each = {
    for i, zone in var.zones : "disk-${i}" => zone
  }

  name     = "sda-${each.key}"
  type     = "network-hdd"
  zone     = each.value
  size     = 15
  image_id = var.disk_image_ids[0]
}

resource "yandex_compute_instance" "instance" {
  for_each = {
    "nginx-1"        => var.zones[0],
    "nginx-2"        => var.zones[1],
    "zabbix"         => var.zones[2],
    "elasticsearch"  => var.zones[2],
    "kibana"         => var.zones[2]
  }

  name                      = "linux-vm-${each.key}"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = each.value

  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk["disk-${count.index}"].id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet[each.value].id
    nat                = var.nat
    security_group_ids = [yandex_vpc_security_group.group1.id]
  }

  metadata = {
    user-data = file(var.yaml)
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_alb_target_group" "foo" {
  name = "homework"

  target {
    for_each    = yandex_compute_instance.instance
    subnet_id   = yandex_vpc_subnet.subnet[each.value].id
    ip_address  = each.value.network_interface.0.ip_address
  }
}

resource "yandex_alb_backend_group" "test-backend-group" {
  name      = "my-backend-group"

  http_backend {
    name               = "test-http-backend"
    weight             = 1
    port               = 80
    target_group_ids   = [yandex_alb_target_group.foo.id]
    tls {
      sni              = "backend-domain.internal"
    }
    load_balancing_config {
      panic_threshold  = 50
    }
    healthcheck {
      timeout          = "1s"
      interval         = "1s"
      http_healthcheck {
        path           = "/"
      }
    }
    http2 = true
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name   = "tf-router"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "vhost"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name         = "my-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.test-backend-group.id
        timeout          = "60s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "my-load-balancer"
  network_id  = yandex_vpc_network.network-1.id

  allocation_policy {
    location {
      zone_id   = var.zona-3
      subnet_id = yandex_vpc_subnet.subnet["zona-3"].id
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
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
