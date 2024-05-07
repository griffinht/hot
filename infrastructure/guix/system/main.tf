terraform {
    required_providers {
        libvirt = {
            source = "dmacvicar/libvirt"
        }
    }

    backend "local" {
        # todo
        path = "terraformstate/terraform.tfstate"
        # use workdir instead of path??
    }
}


/*
variable "libvirt_uri" {
    type = string
    #test locally?
    #default = "qemu:///sesssion"
}

provider "libvirt" {
    uri = var.libvirt_uri
}*/

provider "libvirt" {
    uri = "qemu+tcp://hot-desktop.wg.hot.griffinht.com/session"
}

resource "libvirt_domain" "newvm" {
    name = "newvm"

    network_interface {
        bridge = "br0"
        mac = "52:54:00:AA:BB:CC"
    }

    autostart = true
}
