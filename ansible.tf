# https://www.linkbynet.com/produce-an-ansible-inventory-with-terraform

resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl", {
    ansible_user  = var.ansible_user,
    instance_name = vultr_instance.eph.hostname,
    instance_ip   = vultr_instance.eph.main_ip,
    instance_id   = vultr_instance.eph.id,
    ssh_key_file  = "~/.ssh/${var.ssh_key_name}",
  }
 )
 filename         = "${path.module}/ansible/inventory"
}