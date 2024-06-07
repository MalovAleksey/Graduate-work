output "nat_ip_adress_nginx-1"{
    value = yandex_compute_instance.nginx-1.network_interface.0.nat_ip_address
}

output "nat_ip_adress_nginx-2"{
    value = yandex_compute_instance.nginx-2.network_interface.0.nat_ip_address
}

output "nat_ip_adress_zabbix"{
    value = yandex_compute_instance.zabbix.network_interface.0.nat_ip_address
}

output "nat_ip_adress_Elasticsearch"{
    value = yandex_compute_instance.Elasticsearch.network_interface.0.nat_ip_address
}

output "nat_ip_adress_Kibana"{
    value = yandex_compute_instance.Kibana.network_interface.0.nat_ip_address
}
#########################################################################################

output "ip_adress_nginx-1"{
    value = yandex_compute_instance.nginx-1.network_interface.0.ip_address
}

output "ip_adress_nginx-2"{
    value = yandex_compute_instance.nginx-2.network_interface.0.ip_address
}

output "ip_adress_zabbix"{
    value = yandex_compute_instance.zabbix.network_interface.0.ip_address
}

output "ip_adress_Elasticsearch"{
    value = yandex_compute_instance.Elasticsearch.network_interface.0.ip_address
}

output "ip_adress_Kibana"{
    value = yandex_compute_instance.Kibana.network_interface.0.ip_address
}
###########################################################################################

/*
output "subnet_id_nginx-1"{
    value = yandex_vpc_subnet.subnet-1.id
}

output "subnet_id_nginx-2"{
    value = yandex_vpc_subnet.subnet-2.id
}

output "subnet_id_zabbix"{
    value = yandex_vpc_subnet.subnet-3.id
}

output "nginx-1-fqdn"{
    value = yandex_compute_instance.nginx-1.fqdn
}
*/


output "IP_ADDRESS_LOAD_BALANCER"{
    value = yandex_alb_load_balancer.test-balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
   }   
