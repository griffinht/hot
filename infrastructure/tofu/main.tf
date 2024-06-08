terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
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
