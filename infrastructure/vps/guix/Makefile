.SECONDARY:

SSH_PORT=22
HOST=198.46.248.168

bootstrap.scm: system.scm
	touch '$@'

deploy.scm: system.scm
	touch '$@'

# todo this should probably have a run prereq??
deploy: deploy.scm
	guix deploy "$<"

# todo transitive deps don't work bootstrap.scm: system.scm - maybe touch '$@'
%.qcow2.bin: %.scm
	# todo save provenance
	# https://guix.gnu.org/manual/en/html_node/Building-the-Installation-Image.html
	guix system image --image-type=qcow2 '$<' > '$@' || (rm '$@'; exit 1)

%.img.bin: %.qcow2.bin
	# convert qcow2 image to efi-raw
	qemu-img convert -f qcow2 -O raw "$$(cat $<)" '$@'

inspect.%: %.img.bin
	# inspect image partitions
	fdisk -l "$<"

mount.%: %.img.bin
	# mount image on a loopback device
	losetup todo

# https://guix.gnu.org/manual/en/html_node/Running-Guix-in-a-VM.html
%.qcow2.writable.bin: %.qcow2.bin
	cp "$$(cat $<)" '$@'
	chmod +w '$@'

vm.%: %.qcow2.writable.bin
	# start virtual machine with image
	# https://unix.stackexchange.com/questions/276480/booting-a-raw-disk-image-in-qemu
	qemu-system-x86_64 \
		-nic user,model=virtio-net-pci \
		-enable-kvm -m 2048 \
		-device virtio-blk,drive=myhd \
		-drive 'if=none,file=$<,id=myhd'

rescueinstall: bootstrap.img.bin
	ssh 'root@$(HOST)' 'cat > /dev/vda' < "$$(cat $<)"
	ssh 'root@$(HOST)'

clean:
	rm -f *.bin
