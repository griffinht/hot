terraform {
    required_providers {
        routeros = {
            source = "terraform-routeros/routeros"
        }
    }
}



provider "routeros" {
    hosturl = "api://lil-tik.lan.hot.griffinht.com"
    #hosturl = "api://localhost"
    username = "api"
    # todo lmaco
    password = "bruhbruhbruhbruh"
}


resource "routeros_system_user_group" "api" {
    name = "api"
    policy = ["api", "read", "write", "policy",
        "!dude",
        "!ftp",
        "!local",
        "!password",
        "!reboot",
        "!romon",
        "!sensitive",
        "!sniff",
        "!ssh",
        "!telnet",
        "!test",
        "!tikapp",
        "!web",
        "!winbox"
    ]
    comment = "terraform"
}

resource "routeros_system_user" "api" {
    name = "api"
    group = routeros_system_user_group.api.name
    password = "bruhbruhbruhbruh"
    comment = "terraform"
}




resource "routeros_snmp" "test" {
    enabled = true
}

# dynamic dns for hairpin nat external ip
resource "routeros_ip_firewall_addr_list" "thing" {
    address = "windy.griffinht.com"
    list    = "WANIP"
    comment = "terraform"
}




locals {
    main = yamldecode(file("../main.yml"))
    dns_records = {
        for k, v in local.main : k => v if contains(keys(v), "address")
    }

    dhcp_leases = {
        for k, v in local.main : k => v if contains(keys(v), "mac_address")
    }

    ports = {
        for k, v in local.main : k => v if contains(keys(v), "ports")
    }
}

# todo rename tod dns_record
resource "routeros_ip_dns_record" "dns_records" {
    for_each = local.dns_records
    comment = "terraform ${each.key}"
    name     = "${each.key}.lan.hot.griffinht.com"
    address  = each.value.address
    type     = "A"
}

variable "dhcp_leases" {
    type = map(object({
        address     = string
        mac_address = string
    }))
    default = {
        hot_desktop     = { address = "192.168.0.5", mac_address = "fc:aa:14:b0:1b:64" }
        envy_laptop     = { address = "192.168.0.6", mac_address = "E4:11:5B:61:70:DD" }
        terraria_laptop = { address = "192.168.0.7", mac_address = "04:7c:16:d1:b4:97" }
        mystuff_guix    = { address = "192.168.0.8", mac_address = "52:54:00:d4:ac:e9" }
        cloudtest       = { address = "192.168.0.9", mac_address = "52:54:00:ac:97:88" }
        griffinht       = { address = "192.168.0.10", mac_address = "52:54:00:08:ad:4e" }
        hot             = { address = "192.168.0.11", mac_address = "52:54:00:55:f2:19" }
        hot-data        = { address = "192.168.0.12", mac_address = "52:54:00:ff:50:26" }
    }
}

resource "routeros_ip_dhcp_server_lease" "dhcp_lease" {
    for_each    = local.dhcp_leases
    comment = "terraform ${each.key}"
    address     = each.value.address
    mac_address = each.value.mac_address
    # idk if/why server = defconf is needed
    server = "defconf"
}


/*


#/ip firewall nat add action=masquerade chain=srcnat dst-address=192.168.0.11 out-interface-list=LAN src-address=192.168.0.0/24
#/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=80 to-addresses=192.168.0.11 protocol=tcp
#/ip firewall nat add chain=dstnat action=dst-nat dst-address-list=WANIP dst-port=443 to-addresses=192.168.0.11 protocol=tcp

variable "ip_forwards" {
    type = map(object({
        address     = string
    }))
    default = {
        hot_desktop     = { address = "192.168.0.11" }
        hypervisor = { address = "192.168.0.5" }
        mystuff-guix = { address = "192.168.0.8" }
    }
}

resource "routeros_ip_firewall_nat" "masquerade" {
    for_each      = var.ip_forwards
    comment       = each.key
    action        = "masquerade"
    chain         = "srcnat"
    dst_address = each.value.address
    out_interface_list = "LAN"
    src_address = "192.168.0.0/24"
}


variable "dst_nat" {
    type = map(object({
        address = string
        port = string
        protocol = string
    }))
    default = {
        a = { address = "192.168.0.11", port = 80, protocol = "tcp" },
        b = { address = "192.168.0.11", port = 443, protocol = "tcp" }
    }
}

resource "routeros_ip_firewall_nat" "dst-nat" {
    for_each      = var.dst_nat
    comment       = each.key
    action        = "dst-nat"
    chain         = "dstnat"
    dst_address_list = "WANIP"
    dst_port      = each.value.port
    to_addresses = each.value.address
    protocol = each.value.protocol
}*/
