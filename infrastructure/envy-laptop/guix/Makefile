# port to expose ssh on host (when testing locally)
SSH_PORT=2222

bootstrap.scm: system.scm
deploy.scm: system.scm

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
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(SSH_PORT)-:22' \

# todo this should probably have a run prereq??
deploy: deploy.scm
	guix deploy "$<"

# todo this should probably have a run prereq??
ssh:
	# ignore host's known hosts so we don't mess up localhost with temporary keys
	ssh -p '$(SSH_PORT)' -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@localhost

image: bootstrap.scm
	# todo save provenance
	guix system image '$<'

clean:
	rm -f *.bin
