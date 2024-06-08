terraform {
    required_providers {
        libvirt = {
            source = "dmacvicar/libvirt"
        }
        routeros = {
            source = "terraform-routeros/routeros"
        }
    }
}

provider "libvirt" {
  # Configuration options
}

resource "libvirt_network" "bridge_network" {
    name = "bridge_network"
    mode = "bridge"
    bridge = "br0"
}

variable "domains" {
    type = map(object({
    }))
    default = {
        bruh = {
        }
    }
}

resource "libvirt_domain" "domain" {
    for_each = var.domains
    name = each.key
    type = "qemu"

    network_interface {
        network_id = libvirt_network.bridge_network.id
    }

    autostart = true
}

output "mac" {
    value = {
        for instance in libvirt_domain.domain : instance.name => instance.network_interface[0].mac
    }
}







provider "routeros" {
    hosturl = "api://lil-tik.lan.hot.griffinht.com"
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
}

resource "routeros_system_user" "api" {
    name = "api"
    group = routeros_system_user_group.api.name
    password = "bruhbruhbruhbruh"
}




resource "routeros_snmp" "test" {
    enabled = true
}

resource "routeros_ip_firewall_addr_list" "thing" {
    address = "windy.griffinht.com"
    list    = "WANIP"
}

variable "dns_records" {
    type = map(object({
        address = string
    }))
    default = {
        lil_tik      = { address = "192.168.0.1" }
        fruit_pi     = { address = "192.168.0.2" }
        tp-wap       = { address = "192.168.0.3" }
        hot_desktop  = { address = "192.168.0.5" }
        mystuff_guix = { address = "192.168.0.8" }
        cloudtest    = { address = "192.168.0.9" }
        griffinht    = { address = "192.168.0.10" }
        hot          = { address = "192.168.0.11" }
        hot-data     = { address = "192.168.0.12" }
    }
}

resource "routeros_ip_dns_record" "dns_records" {
    for_each = var.dns_records
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
    for_each    = var.dhcp_leases
    address     = each.value.address
    mac_address = each.value.mac_address
    server = "defconf"
}
