output "os_id" {
  value = data.vultr_os.ubuntu.id
}

output "instance_id" {
  value = vultr_instance.eph.id
}

output "instance_hostname" {
  value = vultr_instance.eph.hostname
}

output "instance_ip" {
  value = vultr_instance.eph.main_ip
}

output "instance_os" {
  value = vultr_instance.eph.os
}

output "ssh_string" {
  value = "ssh -i ~/.ssh/${var.ssh_key_name} root@${vultr_instance.eph.main_ip}"
}

# https://www.linkbynet.com/produce-an-ansible-inventory-with-terraform

resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl", {
    instance_name = vultr_instance.eph.hostname,
    instance_ip   = vultr_instance.eph.main_ip,
    instance_id   = vultr_instance.eph.id,
    ssh_key_file  = "~/.ssh/${var.ssh_key_name}",
  }
 )
 filename = "inventory"
}
