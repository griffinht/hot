.DELETE_ON_ERROR:
# port to expose ssh on host (when testing locally)
SSH_PORT=2222
#HOST=envy-laptop.lan.griffinht.com
HOST=localhost

bootstrap.scm: system.scm
	touch '$@'

guix2.vm.bin: bootstrap.scm
	guix system image --image-type=mbr-raw '$<' > '$@'

run2.vm: guix2.vm.bin
	# https://guix.gnu.org/manual/en/html_node/Invoking-guix-system.html
	cp "$$(cat $<)" /tmp/my-image
	chmod +w /tmp/my-image
	# uefi bios
		#-bios "$$(guix build ovmf)"/share/firmware/ovmf_x64.bin \
	guix shell qemu -- qemu-system-x86_64 -enable-kvm -hda /tmp/my-image \
		-m 2048 \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT)-:22'

clean:
	rm -f *.bin
