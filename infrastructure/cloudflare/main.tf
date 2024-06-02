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
    gcp_internal_ips = {
      "caprover" = "10.142.0.23"
      "compose" = "10.142.0.21"
      "coolify" = "10.142.0.22"
      "dokku" = "10.142.0.24"
    }
    gcp_public_ips = {
      "appliku" = "35.237.190.125"
      "cloud66" = "34.73.180.83"
      "tailscale" = "34.73.227.219"
    }
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
            value = "cool.tail773884.ts.net"
            type = "CNAME"
        }
        cool_all = {
            name = "*.cool"
            value = "cool.griffinht.com"
            type = "CNAME"
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
        }
    }, {
        for name, value in local.gcp_internal_ips :
        name => {
            name = "${name}.gcp_internal"
            value = value
            type = "A"
        }
    })
}

resource "cloudflare_record" "record" {
    for_each = local.computed_records
    zone_id = "d691921860e35a45bc7f99007af14a7d"
    name = each.value.name
    value = each.value.value
    type = each.value.type
    comment = "auto managed by terraform"
}
