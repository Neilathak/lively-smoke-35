---
  - hosts: nginx
    become: true
    tasks:
      - name: Adding Portable IP to LB nodes
        blockinfile:
          path: /etc/network/interfaces.d/50-cloud-init.cfg
          block: |
            auto eth1:1
            iface eth1:1 inet static
            address ${lb_ip}/30
            netmask: ${lb_netmask}
            gateway: ${lb_ip_gateway}
      - name: Install keepalived
        apt:
          name: keepalived
          state: present
      - name: Config keepalived 
        blockinfile:
          path: /etc/keepalived/keepalived.conf
          block: | 
            vrrp_instance VI_1 {
                state MASTER
                interface eth1:1
                virtual_router_id 51
                priority 101
                advert_int 1
                authentication {
                    auth_type PASS
                    auth_pass 1111
                }
                virtual_ipaddress {
                    ${lb_ip}
                }
            }
      - name: Restart networking
        command: ifup eth1:1
      - name: Start service keepalived, if not started
        service:
          name: keepalived
          state: started