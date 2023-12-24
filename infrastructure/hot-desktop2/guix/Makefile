.DELETE_ON_ERROR:

bootstrap.scm: system.scm
	touch '$@'

deploy.scm: system.scm
	touch '$@'

vm.bin: bootstrap.scm
	# --no-graphic no need for graphics here
	# C-a h for help
	# C-a x to exit
	guix system vm --no-graphic --persistent '$<' > '$@'

vm.run: vm.bin
	# share host networking and port forward
	# https://guix.gnu.org/manual/en/html_node/Running-Guix-in-a-VM.html
	# see 12.17.1 Connecting Through SSH
	"$$(cat $<)" \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT)-:22'

mbr-raw.bin: bootstrap.scm
	guix system image --image-type=mbr-raw '$<' > '$@'

mbr-raw.run: mbr-raw.bin
	#cp "$$(cat $<)" /tmp/my-image
	#chmod +w /tmp/my-image
	guix shell qemu -- qemu-system-x86_64 -enable-kvm -hda /tmp/my-image \
		-m 2048 \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT)-:22'

# todo this should probably have a run prereq??
deploy: deploy.scm
	guix deploy "$<"

clean:
	rm -f *.bin
