.DELETE_ON_ERROR:

SSH_PORT=2222

bootstrap.scm: system.scm
	touch '$@'

vm.bin: bootstrap.scm
	guix system vm --no-graphic '$<' > '$@'

vm.run: vm.bin
	# C-a x to quit
	# share host networking and port forward
	# https://guix.gnu.org/manual/en/html_node/Running-Guix-in-a-VM.html
	# see 12.17.1 Connecting Through SSH
	"$$(cat $<)" \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT)-:22'

container.run: bootstrap.scm
	sudo "$$(guix system container --network '$<')"

image-run.bin: bootstrap.scm
	guix system image --image-size=20G --image-type=qcow2 '$<' > '$@'

image-run-temp.bin: image-run.bin
	mktemp > '$@'
	cp "$$(cat '$<')" "$$(cat '$@')"
	chmod +w "$$(cat '$@')"

image.run: image-run-temp.bin
	qemu-system-x86_64 \
		-enable-kvm \
		-drive "file=$$(cat '$<'),format=qcow2" \
		-m 512 \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT)-:22'

image.bin: bootstrap.scm
	guix system image '$<' \
		--image-type=qcow2 \
		--image-size=26G \
		> '$@'

deploy-image: image.bin
	./deploy-image.sh "$$(cat '$<')" dockervm

# todo this should probably have a run prereq??
deploy: deploy.scm
	guix deploy "$<"

clean:
	rm -f *.bin
