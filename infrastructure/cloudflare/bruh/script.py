#!/usr/bin/env python3

import http.client
import os
import json

tag = "hot"
token = os.getenv("CLOUDFLARE_API_TOKEN")
if token is None:
    raise Exception("missing cloudflare api token - set CLOUDFLARE_API_TOKEN env var")

connection = http.client.HTTPSConnection("api.cloudflare.com")
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + token,
}


def response_get_data(response):
    data = json.loads(response.read().decode())
    if response.code != 200:
        return Exception("non 200 code todo " + str(response.code) + str(data))
    if data["success"] is False:
        return Exception(data["errors"])
    # todo read result_info
    # todo pagination
    # todo messages
    return data["result"]
