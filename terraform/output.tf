output "IP_ADDRESS_LOAD_BALANCER"{
    value = yandex_alb_load_balancer.test-balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
   }   

output "nat_ip_adress_bastion-host"{
    value = yandex_compute_instance.bastion-host.network_interface.0.nat_ip_address
}

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

output "ip_adress_bastion_host"{
    value = yandex_compute_instance.bastion-host.network_interface.0.ip_address
}


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


output "fqdn_elasticsearch"{
    value = yandex_compute_instance.Elasticsearch.fqdn
}

output "fqdn_kibana"{
    value = yandex_compute_instance.Kibana.fqdn
}

output "fqdn_nginx-1"{
    value = yandex_compute_instance.nginx-1.fqdn
}

output "fqdn_nginx-2"{
    value = yandex_compute_instance.nginx-2.fqdn
}

output "fqdn_zabbix"{
    value = yandex_compute_instance.zabbix.fqdn
}