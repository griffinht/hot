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

locals {
    gcp_public_ips = {
      "cloud66" = "34.23.115.253"
      "family" = "34.139.123.110"
      "machine" = "34.73.255.44"
      "pet3" = "34.75.72.171"
    }
}

# todo do this
variable "records" {
    type = map(object({
        name = string
        value = string
        type = string
        proxied = optional(bool, false)
    }))
    default = {
        dynamic_dns = {
            name = "windy"
            value = "67.140.90.146"
            type = "A"
        }
        hot = {
            name = "hot"
            value = "windy.griffinht.com"
            type = "CNAME"
        }
        hot_all = {
            name = "*.hot"
            value = "hot.griffinht.com"
            type = "CNAME"
        }
        cool = {
            name = "cool"
            value = "100.117.0.28"
            type = "A"
        }
        cool_all = {
            name = "*.cool"
            value = "cool.griffinht.com"
            type = "CNAME"
        }
        postgres = {
            name = "postgres.ts"
            value = "100.79.87.2"
            type = "A"
        }
        /*
        chilly_1 = {
            name = "chilly"
            value = "ns-cloud-c1.googledomains.com"
            type = "NS"
        }
        chilly_2 = {
            name = "chilly"
            value = "ns-cloud-c2.googledomains.com"
            type = "NS"
        }
        chilly_3 = {
            name = "chilly"
            value = "ns-cloud-c3.googledomains.com"
            type = "NS"
        }
        chilly_4 = {
            name = "chilly"
            value = "ns-cloud-c4.googledomains.com"
            type = "NS"
        }*/
        chilly = {
            name = "chilly"
            value = "chilly-955.pages.dev"
            type = "CNAME"
            proxied = true
        }
        chilly_all = {
            name = "*.chilly"
            value = "34.74.21.105"
            type = "A"
        }
        chilly_iperf = {
            name = "iperf.chilly"
            value = "35.231.59.239"
            type = "A"
        }
        chilly_hetzner = {
            name = "hetzner.chilly"
            value = "5.161.160.132"
            type = "A"
        }
        hot_talos = {
            name = "talos.hot"
            value = "192.168.0.14"
            type = "A"
        }
    }
}

locals {
    computed_records = merge(var.records, {
        for name, value in local.gcp_public_ips :
        name => {
            name = "${name}.gcp"
            value = value
            type = "A"
            proxied = false
        }
    })
}

variable "zone_id" {
    type = string
    default = "d691921860e35a45bc7f99007af14a7d"
}

resource "cloudflare_record" "record" {
    for_each = local.computed_records
    zone_id = var.zone_id
    name = each.value.name
    value = each.value.value
    type = each.value.type
    proxied = each.value.proxied
    comment = "auto managed by terraform"
}
