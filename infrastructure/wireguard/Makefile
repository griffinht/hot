# this can delete private keys otherwise!
.SECONDARY:
.DELETE_ON_ERROR:

%.privatekey:
	wg genkey | sudo tee '$@' > /dev/null
	sudo chmod 400 '$@'

%.pubkey: /etc/wireguard/%.privatekey
	@sudo cat '$<' | wg pubkey

phone: /etc/wireguard/phone-client.privatekey \
	/etc/wireguard/phone-client.conf.qrcode
other-phone: /etc/wireguard/other-phone.privatekey \
	/etc/wireguard/other_phone-client.conf.qrcode
dumb-laptop: /etc/wireguard/dumb-laptop.privatekey \
	/etc/wireguard/dump_laptop-client.conf.less

smart-laptop: \
	/etc/wireguard/hot_desktop.conf \
	/etc/wireguard/envy_laptop.conf \
	/etc/wireguard/nerd_vps.conf

cool-laptop: \
	/etc/wireguard/hot_desktop.conf \
	/etc/wireguard/envy_laptop.conf \
	/etc/wireguard/nerd_vps.conf

#todo pipe fail??
/etc/wireguard/%.conf: /etc/wireguard/local.privatekey
	source ./config.env; ./wg-generate-client-conf.sh "$$$*_publickey" 10.0.0.9 "$$$*_endpoint" "$$$*_allowed" '$<' | sudo tee '$@' > /dev/null
	sudo chmod 400 '$@'

# todo set dns?
/etc/wireguard/%-client.conf: /etc/wireguard/%-client.privatekey
	source ./config.env; ./wg-generate-client-conf.sh "$$hot_desktop_publickey" "$$$*_address" "$$hot_desktop_endpoint" "$$hot_desktop_allowed,192.168.0.5/32" '-' < '$<' > '$@'
	chmod 400 '$@'

/etc/wireguard/%.conf.up: /etc/wireguard/%.conf
	wg-quick up '$*'

%.less: %
	less '$*'

%.qrcode: %
	qrencode -t ansiutf8 < '$*'

clean:
	sudo rm -f /etc/wireguard/envy_laptop.conf
	sudo rm -f /etc/wireguard/hot_desktop.conf
	sudo rm -f /etc/wireguard/nerd_vps.conf
	sudo rm -f /etc/wireguard/phone-client.conf
	sudo rm -f /etc/wireguard/other-phone-client.conf
