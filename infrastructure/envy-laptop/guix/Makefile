# port to expose ssh on host (when testing locally)
#SSH_PORT=2222
SSH_PORT=22
HOST=192.168.0.6
#HOST=localhost

bootstrap.scm: system.scm
	touch '$@'

deploy.scm: system.scm
	touch '$@'

build.docker.bin: bootstrap.scm
	# --network flag is important!
	#  tells guix not to enable networking services which would conflict with docker causing ssh-daemon to fail to start!
	#  --save-provenance isn't needed maybe? idk todo
	guix system image --image-type=docker --network '$<' > '$@' || rm '$@'

image.docker.bin: build.docker.bin
	docker image load

# todo don't use prereq files which can be out of date??
run.docker.bin: image.docker.bin
	docker run --rm -it -p '$(SSH_PORT):22' '$$(cat $<)'

monitor.docker: run.docker.bin
	docker attach "$$(cat $<)"; rm '$<'

# todo shouldn't have stop prereq??
stop.docker: run.docker.bin
	docker stop "$$(cat $<)"

# isn't this debug.docker????
debug.docker: guix.docker
	docker exec -it "$$(cat $<)" /run/current-system/profile/bin/bash --login

guix.vm.bin: bootstrap.scm
	# --save-provenance?
	# --no-graphic no need for graphics here
	# C-a h for help
	# C-a x to exit
	guix system vm --no-graphic --persistent '$<' > '$@' || rm '$@'

run.vm: guix.vm.bin
	# share host networking and port forward
	# https://guix.gnu.org/manual/en/html_node/Running-Guix-in-a-VM.html
	# see 12.17.1 Connecting Through SSH
	"$$(cat $<)" \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT)-:22'

guix2.vm.bin: bootstrap.scm
	# todo save provenance
	guix system image --image-type=qcow2 '$<' > '$@' || rm '$@'

run2.vm: guix2.vm.bin
	# https://guix.gnu.org/manual/en/html_node/Invoking-guix-system.html
	cp "$$(cat $<)" /tmp/my-image.qcow2
	chmod +w /tmp/my-image.qcow2
	guix shell qemu -- qemu-system-x86_64 -enable-kvm -hda /tmp/my-image.qcow2 \
		-m 2048 \
		-bios "$$(guix build ovmf)"/share/firmware/ovmf_x64.bin \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT)-:22'

# todo this should probably have a run prereq??
deploy: deploy.scm
	guix deploy "$<"

# todo this should probably have a run prereq??
ssh:
	# ignore host's known hosts so we don't mess up localhost with temporary keys
	ssh -p '$(SSH_PORT)' -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 'root@$(HOST)'

# todo transitive deps don't work bootstrap.scm: system.scm - maybe touch '$@'
image.bin: bootstrap.scm
	# todo save provenance
	# https://guix.gnu.org/manual/en/html_node/Building-the-Installation-Image.html
	guix system image -t iso9660 '$<' > '$@' || rm '$@'

clean:
	rm -f *.bin
