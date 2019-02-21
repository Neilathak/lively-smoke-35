data "ibm_compute_ssh_key" "deploymentKey" {
  label = "ryan_tycho"
}

resource "ibm_subnet" "floating_ip_subnet" {
  type       = "Portable"
  private    = false
  ip_version = 4
  capacity   = 4
  vlan_id    = "${var.pub_vlan["us-south3"]}"
}

resource "ibm_subnet" "apache_ip_subnet" {
  type       = "Portable"
  private    = true
  ip_version = 4
  capacity   = 8
  vlan_id    = "${var.priv_vlan["us-south3"]}"
}

resource "ibm_compute_vm_instance" "nginx_lb_nodes" {
  count                = "${var.node_count["nginx_lb"]}"
  hostname             = "nginx-lb-${count.index+1}"
  domain               = "${var.domainname}"
  user_metadata        = "${file("install.yml")}"
  os_reference_code    = "${var.os["u16"]}"
  datacenter           = "${var.datacenter["us-south3"]}"
  network_speed        = 1000
  hourly_billing       = true
  private_network_only = false
  flavor_key_name      = "${var.vm_flavor["medium"]}"
  disks                = [200]
  local_disk           = false
  public_vlan_id       = "${var.pub_vlan["us-south3"]}"
  private_vlan_id      = "${var.priv_vlan["us-south3"]}"
  ssh_key_ids          = ["${data.ibm_compute_ssh_key.deploymentKey.id}"]

  tags = [
    "ryantiffany",
  ]
}

resource "ibm_compute_vm_instance" "web_nodes" {
  count                = "${var.node_count["web"]}"
  hostname             = "web-${count.index+1}"
  domain               = "${var.domainname}"
  user_metadata        = "${file("install.yml")}"
  os_reference_code    = "${var.os["u16"]}"
  datacenter           = "${var.datacenter["us-south3"]}"
  network_speed        = 1000
  hourly_billing       = true
  private_network_only = true
  flavor_key_name      = "${var.vm_flavor["medium"]}"
  disks                = [200]
  local_disk           = false
  private_vlan_id      = "${var.priv_vlan["us-south3"]}"
  ssh_key_ids          = ["${data.ibm_compute_ssh_key.deploymentKey.id}"]

  tags = [
    "ryantiffany",
  ]
}

resource "local_file" "output" {
  content = <<EOF
floating_ip = ${cidrhost(ibm_subnet.floating_ip_subnet.subnet_cidr,2)}
floating_netmask = ${cidrnetmask(ibm_subnet.floating_ip_subnet.subnet_cidr)}
web1_ip = ${cidrhost(ibm_subnet.apache_ip_subnet.subnet_cidr,2)}
web2_ip = ${cidrhost(ibm_subnet.apache_ip_subnet.subnet_cidr,3)}
web3_ip = ${cidrhost(ibm_subnet.apache_ip_subnet.subnet_cidr,4)}
web_netmask = ${cidrnetmask(ibm_subnet.apache_ip_subnet.subnet_cidr)}
EOF

  filename = "IPs.env"
}


resource "dnsimple_record" "floating_ip_record" {
  domain     = "${var.domainname}"
  name       = "float"
  value      = "${cidrhost(ibm_subnet.floating_ip_subnet.subnet_cidr,2)}"
  type       = "A"
  ttl        = 900
}

# Use a built-in function cidrhost with index 2 (first usable IP).
output "floating_ip" {
  value = "${cidrhost(ibm_subnet.floating_ip_subnet.subnet_cidr,2)}"
}


output "floating_netmask" {
  value = "${cidrnetmask(ibm_subnet.floating_ip_subnet.subnet_cidr)}"
}

