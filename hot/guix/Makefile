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

debug:
	# todo hardcoded start.bin
	docker exec -ti "$$(cat start.bin)" /run/current-system/profile/bin/bash --login

stop:
	# todo hardcoded start.bin
	docker rm --force "$$(cat start.bin)"



container.bin: system.scm
	# todo sudo
	# otherwise fport thing document the error we get!
	# Note that due to some as yet unresolved limitations we need to run the launcher as the root user, for example with sudo
	# also note this just shares networking - we have to make nginx bind on port 8080 instead of 80 if the host doesn't allow ports <1024
	"$$(sudo guix system container --no-substitutes --network '$<')"

vm.bin: system.scm
	# C-a x to quit
	# todo networking doesn't work!?!?? why???
	"$$(guix system vm '$<' --no-graphic)" \
		-m 1024 \
		-nic 'user,model=virtio-net-pci,hostfwd=tcp::$(HOST_PORT)-:$(CLIENT_PORT)'

# todo https://github.com/pjotrp/guix-notes/blob/master/CONTAINERS.org
%.pack.bin:
	#--entry-point=
	#guix pack -f docker -S /bin=bin nginx > '$@' || rm '$@'
	#guix pack -f docker -S /bin=bin guile nginx > '$@' || rm '$@'
	# todo document error with nonexistent -S /bin=bin with nginx
	# TODO LOOK AT COMPRESSION
	#'--entry-point=sbin/$*' \
	guix pack \
		-f docker \
		--compression=none \
		'$*' > '$@' || (rm '$@' && exit 1)

%.packload.bin: %.pack.bin
	docker load < "$$(cat $<)"

%.packrun: %.packload.bin
	docker run --rm -it 'localhost/$*:latest'# '$*'

clean:
	rm -f *.bin
