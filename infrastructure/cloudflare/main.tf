terraform {
    required_providers {
        cloudflare = {
            source = "cloudflare/cloudflare"
        }
    }

    backend "local" {
        # todo
        path = "terraformstate/terraform.tfstate"
        # use workdir instead of path??
    }
}

provider "cloudflare" {
    api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
    type = string
    sensitive = true
}

resource "cloudflare_record" "dynamic_dns" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = "windy"
    value = "67.140.90.146"
    type = "A"
    comment = "auto managed by terraform"
}

resource "cloudflare_record" "hot" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = "hot"
    value = "windy.griffinht.com"
    type = "CNAME"
    comment = "auto managed by terraform"
}

resource "cloudflare_record" "all_hot" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = "*.hot"
    value = "hot.griffinht.com"
    type = "CNAME"
    comment = "auto managed by terraform"
}

resource "cloudflare_record" "gcpdeb" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = "gcpdeb"
    value = "34.23.115.253"
    type = "A"
    comment = "auto managed by terraform"
}

resource "cloudflare_record" "hotter" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = "hotter"
    value = "gcpdeb.griffinht.com"
    type = "CNAME"
    comment = "auto managed by terraform"
}

resource "cloudflare_record" "hotter_all" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = "*.hotter"
    value = "hotter.griffinht.com"
    type = "CNAME"
    comment = "auto managed by terraform"
}
