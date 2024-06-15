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




locals {
    main = yamldecode(file("../main.yml"))

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
        mac = each.value.mac_address
    }

    autostart = true
}

/*
resource "libvirt_cloudinit_disk" "commoninit" {
    name      = "commoninit.iso"
    user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
    template = file("${path.module}/cloud_init.cfg")
}*/

# todo ignition https://registry.terraform.io/providers/multani/libvirt/latest/docs/resources/coreos_ignition
