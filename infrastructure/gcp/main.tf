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

resource "google_compute_instance" "default" {
    name = "bruh"
    machine_type = "n4-standard-2"
    zone = "us-east1-b"

    tags = [ "allow-all" ]

    network_interface {
        network = "default"

        access_config {
            # required for public access
        }
    }

    metadata = {
        ssh-keys = <<EOF
root:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlrXoJEmDX/hi1wvH3M2NNYm2saKxrC+ELNyt3v1pBI griffin@cool-laptop
EOF
        # enable root login
        # todo too much code! delete this code!
        startup-script = file("startup.sh")
        # serial-port-enable = "TRUE"
    }

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-12"
        }
    }
}

output "ip" {
    value =  google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
