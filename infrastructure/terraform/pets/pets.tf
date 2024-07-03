/*
resource "google_storage_bucket" "image_bucket" {
    name     = "hot_custom_image_bucket"
    location = local.region
}

resource "google_storage_bucket_object" "nix" {
    name   = "nix.raw.tar.gz"
    source = "/nix/store/m0kjnyzi2wllhj8z7lfs5mpamh7fybpw-google-compute-image/nixos-image-24.11pre630522.3305b2b25e4a-x86_64-linux.raw.tar.gz"
    bucket = google_storage_bucket.image_bucket.name
}

resource "google_compute_image" "custom_image" {
    name        = "my-custom-image"
    raw_disk {
        source = google_storage_bucket_object.nix.self_link
    }
}

resource "google_compute_disk" "pet_boot" {
    name = "pet-boot"
    zone = local.zone
    image = google_compute_image.custom_image.name
}

# Using pd-standard because it's the default for Compute Engine
resource "google_compute_disk" "pet" {
    name = "pet-persist"
    type = "pd-standard"
    size = "1"
    zone = local.zone
}

resource "google_compute_instance" "pet" {
    name         = "pet"
    machine_type = "e2-small"
    zone = local.zone

    tags = [local.tailscale_tag_init]

    boot_disk {
        source      = google_compute_disk.pet_boot.id
        device_name = google_compute_disk.pet_boot.name
    }

    attached_disk {
        source      = google_compute_disk.pet.id
        device_name = google_compute_disk.pet.name
    }

    network_interface {
        network = var.network
        access_config {
            # Ephemeral IP
        }
    }
}*/

/*
resource "google_compute_disk" "pet_boot" {
    name = "pet-boot"
    zone = local.zone
    image = "debian-cloud/debian-12"
}*/

/*
resource "google_compute_disk" "pet" {
    name = "pet-persist"
    type = "pd-standard"
    size = "10"
    zone = local.zone
}

resource "google_compute_instance" "pet" {
    name         = "pet"
    machine_type = "e2-small"
    zone = local.zone

    metadata = local.instance_metadata

    tags = [local.tailscale_tag_init]

    network_interface {
        network = var.network
        access_config {
            # Ephemeral IP
        }
    }

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-12"
        }
    }

    attached_disk {
        source      = google_compute_disk.pet.id
        device_name = google_compute_disk.pet.name
    }
}

# todo add pet2

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
        hot = {
            name = "hot"
            image = "debian-cloud/debian-12"
            tags = ["tailscale"]
        }
        griffinht = {
            name = "griffinht"
            image = "debian-cloud/debian-12"
            tags = ["custom"]
        }
    }
}*/
