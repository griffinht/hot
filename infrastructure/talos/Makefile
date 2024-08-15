.DELETE_ON_ERROR:

controlplane.json: /home/griffin/secrets/talos/secrets.json
	touch '$@'

secrets.json:
	#talosctl gen config talos-hot https://talos.hot.griffinht.com:6443 --output-types controlplane -o - \
	#	| talosctl gen secrets --from-controlplane-config /dev/stdin -o /dev/stdout --force \
	talosctl gen secrets -o /dev/stdout --force \
		| yq '$<' -o json > '$@'

validate: controlplane.json
	jsonnet '$<' | talosctl validate --mode metal --config /dev/stdin

# maintenence mode
disks:
	talosctl -n talos.hot.griffinht.com disks --insecure

# maintenence mode
apply-config: controlplane.json
	jsonnet '$<' | talosctl -n talos.hot.griffinht.com apply-config --insecure --file /dev/stdin

# booting and production mode
talosconfig.json: controlplane.json
	jsonnet '$<' | ./talos-gen-config.py --with-secrets /home/griffin/secrets/talos/secrets.json --output-types talosconfig --output - | yq -o json > '$@'

bootstrap: talosconfig.json
	talosctl --talosconfig '$^' -n 192.168.0.14 -e 192.168.0.14 bootstrap



#talosctl gen config talos-hot https://talos.hot.griffinht.com:6443 --with-secrets ~/secrets/talos.json --output-types talosconfig -o - | yq -o json - > talosconfig.json
