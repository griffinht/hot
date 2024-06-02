variable "project" {}

provider "google" {
    project = var.project
}

resource "google_compute_firewall" "allow-all" {
    name    = "allow-all"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["0-65535"]
    }

    allow {
        protocol = "udp"
        ports    = ["0-65535"]
    }

    allow {
        protocol = "icmp"
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["allow-all"]
}

variable "instances" {
    type = map(object({
        name = string
        machine_type = optional(string, "e2-small")
        tags = optional(list(string), [])
        image = string
    }))
    default = {
        compose = {
            name = "compose"
            machine_type = "e2-medium"
            #tags = [ "allow-all" ]
            image = "debian-cloud/debian-12"
        }
        /*
        swarm = {
            name = "swarm"
            machine_type = "e2-medium"
            #tags = [ "allow-all" ]
            image = "debian-cloud/debian-12"
        }
        kubernetes = {
            name = "swarm"
            machine_type = "e2-medium"
            #tags = [ "allow-all" ]
            image = "debian-cloud/debian-12"
        }*/
        dokku = {
            name = "dokku"
            image = "debian-cloud/debian-12"
        }
        caprover = {
            name = "caprover"
            image = "ubuntu-os-cloud/ubuntu-2204-lts"
        }
        coolify = {
            name = "coolify"
            image = "debian-cloud/debian-12"
        }
    }
}

variable "instances_public" {
    type = map(object({
        name = string
        machine_type = optional(string, "e2-small")
        tags = optional(list(string), [])
        image = string
    }))
    default = {
        tailscale = {
            name = "tailscale"
            image = "debian-cloud/debian-12"
        }
        cloud66 = {
            name = "cloud66"
            image = "ubuntu-os-cloud/ubuntu-2004-lts"
        }
        appliku = {
            name = "appliku"
            image = "debian-cloud/debian-12"
        }
    }
}


locals {
    instance_metadata = {
        ssh-keys = <<EOF
root:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlrXoJEmDX/hi1wvH3M2NNYm2saKxrC+ELNyt3v1pBI griffin@cool-laptop
EOF
        # enable root login
        # todo too much code! delete this code!
        startup-script = file("startup.sh")
        # serial-port-enable = "TRUE"
    }
}

resource "google_compute_instance" "instance" {
    for_each = var.instances
    name = each.value.name
    machine_type = each.value.machine_type
    zone = "us-east1-b"

    tags = each.value.tags

    network_interface {
        network = "default"
    }

    metadata = local.instance_metadata

    boot_disk {
        initialize_params {
            image = each.value.image
        }
    }
}

resource "google_compute_instance" "instance_public" {
    for_each = var.instances_public
    name = each.value.name
    machine_type = each.value.machine_type
    zone = "us-east1-b"

    tags = each.value.tags

    network_interface {
        network = "default"

        access_config {
            # required for public ipv4
        }
    }

    metadata = local.instance_metadata

    boot_disk {
        initialize_params {
            image = each.value.image
        }
    }
}

output "instance_public_ips" {
    value = {
        for instance in google_compute_instance.instance_public : instance.name => instance.network_interface[0].access_config[0].nat_ip
    }
}
