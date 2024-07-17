variable "project" {
    default = "griffinht-cloudlab"
}

resource "google_storage_bucket" "image_bucket" {
    name     = "homeassistant_image_bucket"
    location = local.region
}

resource "google_storage_bucket_object" "homeassistant" {
    name   = "homeassistant.qcow2"
    source = "haos_ova-12.4.qcow2"
    bucket = google_storage_bucket.image_bucket.name
}

resource "google_compute_image" "homeassistant" {
    name = "homeassistant"
    raw_disk {
        source = google_storage_bucket_object.homeassistant.self_link
    }
}

resource "google_compute_disk" "homeassistant" {
    name = "homeassistant-boot"
    zone = local.zone
    image = google_compute_image.homeassistant.name
    #type = "pd-standard"
    size = "32"
}

resource "google_compute_instance" "homeassistant" {
    name         = "homeassistant"
    machine_type = "e2-small"
    zone = local.zone

    tags = [local.tailscale_tag_init]

    boot_disk {
        source      = google_compute_disk.homeassistant.id
        device_name = google_compute_disk.homeassistant.name
    }

    attached_disk {
        source      = google_compute_disk.homeassistant.id
        device_name = google_compute_disk.homeassistant.name
    }

    network_interface {
        network = var.network
        access_config {
            # Ephemeral IP
        }
    }
}
