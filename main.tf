data "vultr_os" "ubuntu" {
  filter {
    name   = "name"
    values = [var.ubuntu_20]
  }
}

data "vultr_ssh_key" "my_ssh_key" {
  filter {
    name = "name"
    values = [var.vultr_ssh_key_name]
  }
}

resource "vultr_instance" "eph" {
  plan = "vc2-1c-1gb"
  region = "ams"
  os_id = data.vultr_os.ubuntu.id
  ssh_key_ids = [data.vultr_ssh_key.my_ssh_key.id]
  label = var.instance_name
  tag = var.instance_name
  hostname = var.instance_name
  enable_ipv6 = false
  backups = "disabled"
  ddos_protection = false
  activation_email = false

  provisioner "remote-exec" {
    inline = [
      "echo Done!"
    ]

    connection {
      host        = vultr_instance.eph.main_ip
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/${var.ssh_key_name}")
    }
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = <<EOT
      if [ "${var.ansible_enabled}" == "true" ]
      then
        ansible-playbook -u root -i '${self.main_ip},' --private-key "~/.ssh/${var.ssh_key_name}" -e pub_key="~/.ssh/${var.ssh_key_name}.pub" ./ansible/packages-install.yml
      else
        echo 'skipping ansible'
      fi
    EOT
  }
}
