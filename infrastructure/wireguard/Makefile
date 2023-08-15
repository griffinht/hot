.DELETE_ON_ERROR:

/etc/wireguard/private.key:
	wg genkey > '$@'
	chmod 400 '$@'

pubkey: /etc/wireguard/private.key
	@wg pubkey < '$<'

/etc/wireguard/%.conf: /etc/wireguard/private.key \
	config.env \
	wg-generate-client-conf.sh 
	source ./config.env; ./wg-generate-client-conf.sh "$$$*_publickey" "$$$*_address" "$$$*_endpoint" "$$$*_allowed" < '$<' > '$@'
	chmod 400 '$@'

/etc/wireguard/%.conf.up: /etc/wireguard/%.conf
	wg-quick up '$*'

%.less: %
	less '$*'

%.qrcode: %
	qrencode -t ansiutf8 < '$*'
