output "ip_adress_vm1"{
    value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "ip_adress_vm2"{
    value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}