HOST_PORT=8080
CLIENT_PORT=80

image.bin: system.scm
	# todo networking necessary if we already don't have anything?
	guix system image --image-type=docker --network '$<' > '$@' || rm '$@'

docker.bin: image.bin
	docker load < "$$(cat $<)"
	touch '$@'

start.bin: docker.bin
	docker run --detach --rm -it -p '$(HOST_PORT):$(CLIENT_PORT)' localhost/guix:latest > '$@' || rm '$@'

monitor: start.bin
	docker attach "$$(cat $<)"; rm '$<'

debug: start.bin
	docker exec -ti "$$(cat $<)" /run/current-system/profile/bin/bash --login

stop: start.bin
	docker rm --force "$$(cat $<)"



conatiner.bin: system.scm
	"$$(guix system container '$<')"

vm.bin: system.scm
	# C-a x to quit
	"$$(guix vm '$<' -m 1024 -nic user,model=virtio-net-pci,hostfwd=tcp:$(HOST_PORT)-:$(CLIENT_PORT) --no-graphic)"


clean:
	rm -f *.bin
