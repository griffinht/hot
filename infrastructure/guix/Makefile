.SECONDARY:

SYSTEM=system.scm
DEPLOY=deploy.scm

%/vm.bin: %/$(SYSTEM)
	guix system vm --no-graphic '$<' > '$@'

%/vm.run: %/vm.bin
	. ./dev.env \
		&& "$$(cat '$<')" \
		-nic "user,model=virtio-net-pci,hostfwd=tcp::$$SSH_PORT-:22"

%/container.run: %/$(SYSTEM)
	sudo "$$(guix system container --network '$<')"

%/image.bin: %/$(SYSTEM)
	guix system image --image-size=20G --image-type=qcow2 '$<' > '$@'

%/image-temp.bin: %/image.bin
	mktemp > '$@'
	cp "$$(cat '$<')" "$$(cat '$@')"
	chmod +w "$$(cat '$@')"

%/image.run: %/image-temp.bin
	. ./dev.env \
		&& qemu-system-x86_64 \
		-enable-kvm \
		-drive "file=$$(cat '$<'),format=qcow2" \
		-m 512 \
		-nic "user,model=virtio-net-pci,hostfwd=tcp::$$SSH_PORT-:22"

%/deploy: %/$(DEPLOY)
	guix deploy '$<'
