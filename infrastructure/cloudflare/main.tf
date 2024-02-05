# Configure the Cloudflare provider using the required_providers stanza
# required with Terraform 0.13 and beyond. You may optionally use version
# directive to prevent breaking changes occurring unannounced.
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

variable "cloudflare_api_token" {
    type = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "www" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    type = "A"
    name = "bruhtest"
    value = "192.0.0.1"
}
