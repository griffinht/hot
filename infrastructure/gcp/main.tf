variable "project" {}

provider "google" {
    project = var.project
}

variable "network" {
    type = string
    default = "default"
}

# https://tailscale.com/kb/1147/cloud-gce#step-2-allow-udp-port-41641
resource "google_compute_firewall" "tailscale_init" {
    name    = "tailscale-init"
    network = var.network
    priority = 1000

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["tailscale-init"]
}

resource "google_compute_firewall" "tailscale_deny" {
    name    = "tailscale-deny"
    network = var.network
    priority = 1001

    deny {
        protocol = "tcp"
        ports = ["0-65535"]
    }

    deny {
        protocol = "udp"
        ports = ["0-65535"]
    }

    deny {
        protocol = "icmp"
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["tailscale"]
}

resource "google_compute_firewall" "tailscale_allow" {
    name    = "tailscale-allow"
    network = var.network

    allow {
        protocol = "icmp"
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["tailscale"]
}

variable "instances_public" {
    type = map(object({
        name = string
        machine_type = optional(string, "e2-small")
        tags = optional(list(string), [])
        image = string
        desired_status = optional(string, "RUNNING")
    }))
    default = {
        /*
        cloud66 = {
            name = "cloud66"
            image = "ubuntu-os-cloud/ubuntu-2004-lts"
            machine_type = "e2-medium"
        }*/
        compose = {
            name = "compose"
            machine_type = "e2-medium"
            image = "debian-cloud/debian-12"
            tags = ["tailscale"]
        }
        dokku = {
            name = "dokku"
            image = "debian-cloud/debian-12"
            tags = ["tailscale"]
            desired_status = "TERMINATED"
        }
        coolify = {
            name = "coolify"
            image = "debian-cloud/debian-12"
            tags = ["tailscale"]
            desired_status = "TERMINATED"
        }
        /*
        swarm = {
            name = "swarm"
            machine_type = "e2-medium"
            image = "debian-cloud/debian-12"
        }
        kubernetes = {
            name = "swarm"
            machine_type = "e2-medium"
            image = "debian-cloud/debian-12"
        }*/
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

resource "google_compute_instance" "instance_public" {
    for_each = var.instances_public
    name = each.value.name
    machine_type = each.value.machine_type
    zone = "us-east1-b"

    tags = each.value.tags
    desired_status = each.value.desired_status

    network_interface {
        network = var.network

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

/*
output "gcp_public_ips" {
    value = {
        for instance in google_compute_instance.instance_public : instance.name => instance.network_interface[0].access_config[0].nat_ip
    }
}*/
output "gcp_public_ips" {
    value = {
        for instance in google_compute_instance.instance_public : instance.name => instance.network_interface[0].access_config[0].nat_ip
        if ! contains(instance.tags, "tailscale")
    }
}

output "tailscale_init_ips" {
    value = {
        for instance in google_compute_instance.instance_public : instance.name => instance.network_interface[0].access_config[0].nat_ip
        if contains(instance.tags, "tailscale-init")
    }
}
