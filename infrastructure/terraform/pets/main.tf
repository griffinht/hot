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

    tailscale_tag = "tailscale"
    tailscale_tag_init = "tailscale-init"
    region = "us-east1"
    zone = "us-east1-b"
}

provider "google" {
    project = "usedby"
}

variable "network" {
    type = string
    default = "default"
}

variable "instances" {
    type = map(object({
        name = string
        machine_type = optional(string, "e2-small")
        tags = optional(list(string), [])
        image = string
        desired_status = optional(string, "RUNNING")
    }))
    default = {
        hot = {
            name = "hot"
            image = "debian-cloud/debian-12"
            tags = ["bruh"]
        }
        griffinht = {
            name = "griffinht"
            image = "debian-cloud/debian-12"
            tags = ["bruh"]
        }
    }
}



resource "google_compute_disk" "disk" {
    for_each = var.instances
    name = "pets-disk-${each.value.name}"
    # Using pd-standard because it's the default for Compute Engine
    type = "pd-standard"
    size = "10"
    zone = local.zone
}

resource "google_compute_instance" "instance" {
    for_each = var.instances

    name = "pets-${each.value.name}"
    machine_type = each.value.machine_type
    zone = local.zone

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

    attached_disk {
        source      = google_compute_disk.disk[each.value.name].id
        device_name = google_compute_disk.disk[each.value.name].name
    }
}

output "gcp_public_ips" {
    value = {
        for instance in google_compute_instance.instance : instance.name => instance.network_interface[0].access_config[0].nat_ip
    }
}
