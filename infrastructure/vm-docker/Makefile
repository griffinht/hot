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

image.bin: bootstrap.scm
	guix system image '$<' \
		--image-type=qcow2 \
		--image-size=20G \
		> '$@'

deploy-image: image.bin
	./deploy-image.sh '$<'






efi-raw-custom.bin: image.scm
	guix system image '$<' -v 10 --on-error=backtrace > '$@'

efi-raw.bin: bootstrap.scm
	guix system image '$<' --image-type=mbr-hybrid-raw > '$@'

/tmp/my-image: efi-raw-custom.bin
	cp "$$(cat $<)" '$@'
	chmod +w '$@'
	#truncate --size=+8G '$@'
	#echo -e 'n\n\n\n\n\nt\n\nswap\nw\n' | fdisk '$@'

bruh.img.bin: /tmp/my-image
	mv '$<' '$@'

run: /tmp/my-image
	guix shell qemu -- qemu-system-x86_64 -enable-kvm -hda '$<' \
		-m 2048 \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT)-:22'

# todo this should probably have a run prereq??
deploy: deploy.scm
	guix deploy "$<"

clean:
	rm -f *.bin
