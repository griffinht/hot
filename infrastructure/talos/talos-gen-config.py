#!/usr/bin/env python3

import sys
import json
import subprocess

data = json.loads(sys.stdin.read())

name = data['cluster']['clusterName']
endpoint = data['cluster']['controlPlane']['endpoint']

#print(f"{name} {endpoint}")
args = ["talosctl", "gen", "config", name, endpoint] + sys.argv[1:]

subprocess.run(args)
