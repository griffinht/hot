#systemctl --user enable podman.socket
#Created symlink /var/home/docker-user/.config/systemd/user/sockets.target.wants/podman.socket → /usr/lib/systemd/user/podman.socket.
#DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock docker ps
http: envylaptop.ign
	@# https://docs.fedoraproject.org/en-US/fedora-coreos/bare-metal/#_installing_from_live_iso
	@# insecure ignition because we are serving http (fine because its local, don't do this over the internet)
	@echo 'sudo coreos-installer install /dev/sda --ignition-url http://192.168.0.x:8000/$< --insecure-ignition'
	@echo
	python3 -m http.server

envylaptop.ign: envylaptop.yml
	source ./envylaptop.env; envsubst < '$<' | podman run --rm -i quay.io/coreos/butane:release --pretty --strict > '$@'

clean:
	rm -r envylaptop.ign
