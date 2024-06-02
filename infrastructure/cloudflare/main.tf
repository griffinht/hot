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

# todo do this
variable "records" {
    type = map(object({
        name = string
        value = string
        type = string
    }))
    default = {
        dynamic_dns = {
            name = "windy"
            value = "67.140.90.146"
            type = "A"
        }
    }
}

resource "cloudflare_record" "record" {
    for_each = var.records
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = each.value.name
    value = each.value.value
    type = each.value.type
    comment = "auto managed by terraform"
}

resource "cloudflare_record" "hot" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = "hot"
    value = "windy.griffinht.com"
    type = "CNAME"
    comment = "auto managed by terraform"
}

resource "cloudflare_record" "hot_all" {
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

resource "cloudflare_record" "cool" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = "cool"
    value = "cool.tail773884.ts.net"
    type = "CNAME"
    comment = "auto managed by terraform"
}
resource "cloudflare_record" "cool_all" {
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = "*.cool"
    value = "cool.griffinht.com"
    type = "CNAME"
    comment = "auto managed by terraform"
}
