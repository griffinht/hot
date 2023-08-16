.SECONDARY:

SSH_PORT_LOCAL=10022

HOST=nerd-vps.griffinht.com

deploy.scm: system.scm
	touch '$@'

# todo transitive deps don't work bootstrap.scm: system.scm - maybe touch '$@'
%.qcow2path.bin: %.scm
	# todo save provenance?
	# https://guix.gnu.org/manual/en/html_node/Building-the-Installation-Image.html
	guix system image --image-type=qcow2 '$<' > '$@' || (rm '$@'; exit 1)

%.img.bin: %.qcow2path.bin
	# convert qcow2 image to efi-raw
	qemu-img convert -f qcow2 -O raw "$$(cat $<)" '$@'

inspect.%: %.img.bin
	# inspect image partitions
	fdisk -l "$<"

mount.%: %.img.bin
	# mount image on a loopback device for inspection
	losetup todo

%.qcow2.writable.bin: %.qcow2path.bin
	# writable qcow2 image, the %.qcow2path.bin is read onlyt
	cp "$$(cat $<)" '$@'
	chmod +w '$@'

vm.%: %.qcow2.writable.bin
	# local testing vm
	# start virtual machine with image
	# https://guix.gnu.org/manual/en/html_node/Running-Guix-in-a-VM.html
	qemu-system-x86_64 \
		-nic user,model=virtio-net-pci \
		-enable-kvm -m 2048 \
		-device virtio-blk,drive=myhd \
		-drive 'if=none,file=$<,id=myhd'
vm2.%: %.scm
	# local testing vm using guix system
	# C-a x to quit
	$$(guix system vm '$<' --no-graphic) \
		-m 1024 \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT_LOCAL)-:22,hostfwd=tcp::51820-:51820'
container.%: %.scm
	# https://guix.gnu.org/manual/en/html_node/Invoking-guix-system.html
	# currently must be run as root
	# C-c to exit
	sudo "$$(guix system container '$<')"

docker.%: %.scm
	# docker stop $id to remove
	# --network to disable Guix networking services so they do not interfere with Docker
	# todo try to disable gzip compression its so slow
	docker load < "$$(guix system image \
		--image-type=docker \
		--network \
		$<)"
	docker run --rm -p $(SSH_PORT_LOCAL):22 -p 51820:51280 localhost/guix:latest

ssh.local:
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p '$(SSH_PORT_LOCAL)' 'root@localhost'

rescueinstall: bootstrap.img.bin
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 'root@$(HOST)' 'cat > /dev/vda' < '$<'
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 'root@$(HOST)'
	# cfdisk delete old /dev/vda2 partition and make new big partition to span the whole disk
	# then resize2fs /dev/vda2

deploy: deploy.scm
	guix deploy "$<"

ping:
	ping '$(HOST)'

ssh:
	ssh 'root@$(HOST)'

clean:
	rm -f *.bin
