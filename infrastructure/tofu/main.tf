terraform {
    required_providers {
        libvirt = {
            source = "dmacvicar/libvirt"
        }
        /*
        routeros = {
            source = "terraform-routeros/routeros"
        }*/
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

locals {
    main = yamldecode(file("main.yml"))

    domains = {
        for k, v in local.main : k => v if contains(keys(v), "domain")
    }
}

resource "libvirt_domain" "domain" {
    for_each = local.domains
    name = each.key
    type = "qemu"

    network_interface {
        bridge = libvirt_network.bridge_network.bridge
        #network_id = libvirt_network.bridge_network.id
    }

    autostart = true
}

output "mac" {
    value = {
        for instance in libvirt_domain.domain : instance.name => instance.network_interface[0].mac
    }
}
