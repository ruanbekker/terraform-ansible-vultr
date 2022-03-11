# terraform-ansible-vultr
Using Terraform and Ansible for Vultr Instances

## Requirements

- VULTR API Key (and set to the env: `export TF_VAR_vultr_api_key=""`
- Terraform
- Ansible
- Two ssh keys `~/.ssh/id_rsa` and `~/.ssh/vultr` (in my case)

## Usage

Create a python virtual environment:

```bash
$ python3 -m virtualenv .venv
$ source .venv/bin/activate
```

Install the dependencies (ansible):

```bash
$ pip install -r deps/requirements.txt
```

Set the VULTR API Key to the environment:

```bash
$ export TF_VAR_vultr_api_key=xx
```

Initialize terraform:

```bash
$ terraform init
```

Do a terraform plan:

```bash
$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.ansible_inventory will be created
  + resource "local_file" "ansible_inventory" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./ansible/inventory"
      + id                   = (known after apply)
    }

  # vultr_instance.eph will be created
  + resource "vultr_instance" "eph" {
      + activation_email       = false
      + allowed_bandwidth      = (known after apply)
      + app_id                 = (known after apply)
      + backups                = "disabled"
      + date_created           = (known after apply)
      + ddos_protection        = false
      + default_password       = (sensitive value)
      + disk                   = (known after apply)
      + enable_ipv6            = false
      + enable_private_network = false
      + features               = (known after apply)
      + firewall_group_id      = (known after apply)
      + gateway_v4             = (known after apply)
      + hostname               = "eph-instance"
      + id                     = (known after apply)
      + internal_ip            = (known after apply)
      + kvm                    = (known after apply)
      + label                  = "eph-instance"
      + main_ip                = (known after apply)
      + netmask_v4             = (known after apply)
      + os                     = (known after apply)
      + os_id                  = 387
      + plan                   = "vc2-1c-1gb"
      + power_status           = (known after apply)
      + ram                    = (known after apply)
      + region                 = "ams"
      + reserved_ip_id         = (known after apply)
      + script_id              = (known after apply)
      + server_status          = (known after apply)
      + snapshot_id            = (known after apply)
      + ssh_key_ids            = [
          + "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx",
        ]
      + status                 = (known after apply)
      + tag                    = "eph-instance"
      + user_data              = (known after apply)
      + v6_main_ip             = (known after apply)
      + v6_network             = (known after apply)
      + v6_network_size        = (known after apply)
      + vcpu_count             = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_hostname = "eph-instance"
  + instance_id       = (known after apply)
  + instance_ip       = (known after apply)
  + instance_os       = (known after apply)
  + os_id             = "387"
  + ssh_string        = (known after apply)

```

Provision the VULTR instance by running a apply:

```bash
$ terraform apply
...
instance_hostname = "eph-instance"
instance_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx"
instance_ip = "1x.x.x.x"
instance_os = "Ubuntu 20.04 x64"
os_id = "387"
ssh_string = "ssh -i ~/.ssh/vultr root@1x.x.x.x"
ansible_command = "ansible-playbook -e pub_key=~/.ssh/vultr.pub -e os_user=snake ansible/packages-install.yml"
```

Deploy the software on the instance:

```bash
$ ansible-playbook -e pub_key=~/.ssh/vultr.pub -e os_user=snake ansible/packages-install.yml
...

PLAY RECAP *********************************************************************************************************************************
eph-instance               : ok=8    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Test ssh as root:

```bash
$ ssh -i ~/.ssh/vultr root@1x.x.x.x
```

The playbook created a user `snake` and added the public key of `~/.ssh/id_rsa.pub` to the authorized keys for the user, and enabled passwordless sudo access:

```bash
$ ssh -i ~/.ssh/id_rsa snake@1x.x.x.x
$ sudo uptime
 11:05:43 up 38 min,  1 user,  load average: 0.00, 0.00, 0.05
```

Cleanup:

```bash
$ terraform destroy
...
Destroy complete! Resources: 2 destroyed.
```

## Resources

### Ansible Resources

Inventory:

- https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
- https://www.linkbynet.com/produce-an-ansible-inventory-with-terraform

Project Structure:

- https://github.com/enginyoyen/ansible-best-practises
- https://github.com/ansiblejunky/ansible-examples-repos-playbooks

### Terraform Resources

Variables:

- https://www.terraform.io/docs/language/values/variables.html
