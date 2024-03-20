output "nat_ip_adress_nginx-1"{
    value = yandex_compute_instance.nginx-1.network_interface.0.nat_ip_address
}

output "nat_ip_adress_nginx-2"{
    value = yandex_compute_instance.nginx-2.network_interface.0.nat_ip_address
}

output "nat_ip_adress_zabbix"{
    value = yandex_compute_instance.zabbix.network_interface.0.nat_ip_address
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

###########################################################################################

output "subnet_id_nginx-1"{
    value = yandex_vpc_subnet.subnet-1.id
}

output "subnet_id_nginx-2"{
    value = yandex_vpc_subnet.subnet-2.id
}

output "subnet_id_zabbix"{
    value = yandex_vpc_subnet.subnet-3.id
}