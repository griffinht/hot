locals {
    #zone = "us-east1-b"
    tailscale_tag = "tailscale"
    tailscale_tag_init = "tailscale-init"
    region = "us-east1"
    zone = "us-east1-b"
}

provider "google" {
    project = "griffinht-cloudlab"
}

variable "network" {
    type = string
    default = "default"
}
