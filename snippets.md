## Dnsimple config
```
variable dnsimple_token {}
variable dnsimple_account {}
provider "dnsimple" {
  token   = "${var.dnsimple_token}"
  account = "${var.dnsimple_account}"
}

```

## Ansible inventory

```
resource "ansible_group" "web" {
  depends_on = ["ibm_compute_vm_instance.node"]
  inventory_group_name = "web"
}

resource "ansible_host" "node1_hostentry" {
  depends_on = ["ansible_group.web"]
    inventory_hostname = "node-1"
    groups = ["web"]
    vars {
        ansible_host = "${ibm_compute_vm_instance.node.0.ipv4_address}"
        ansible_user = "ryan"
    }
}

resource "ansible_host" "node2_hostentry" {
  depends_on = ["ansible_host.node1_hostentry"]
    inventory_hostname = "node-2"
    groups = ["web"]
    vars {
        ansible_host = "${ibm_compute_vm_instance.node.1.ipv4_address}"
        ansible_user = "ryan"
    }
}
```

```
resource "local_file" "output" {
content = <<EOF
"${ibm_compute_vm_instance.node.0.ipv4_address_private}"
EOF

    filename = "./file.txt"
}

resource "local_file" "rendered" {
  content = <<EOF
${data.template_file.init.rendered}
EOF

  filename = "./rendered.env"
}
```