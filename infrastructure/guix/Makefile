.SECONDARY:
.DELETE_ON_ERROR:

SYSTEM=system.scm
LOAD_PATH=--load-path=channel
SSH_KEY=id_ed25519.bin

id_%.bin:
	ssh-keygen -t $* -f '$@' -N ""
	mv '$@.pub' 'id_$*.pub.bin'

# debug thing, todo use make for this idk
load:
	echo '(use-modules (griffinht system) (griffinht deploy))' | guix repl $(LOAD_PATH)

all.vm.bin: \
	docker/vm.bin \
	dockerrootless/vm.bin \
	podman/vm.bin \
	podmanrootless/vm.bin

channel/griffinht/system.scm: $(SSH_KEY)
	touch '$@'

channel/griffinht/deploy.scm: $(SSH_KEY)
	touch '$@'

%/$(DEPLOY): channel/griffinht/deploy.scm
	touch '$@'

%/$(SYSTEM): channel/griffinht/system.scm
	touch '$@'

%/vm.bin: %/$(SYSTEM)
	guix system $(LOAD_PATH) vm --no-graphic '$<' > '$@'

%/vm.run: %/vm.bin
	"$$(cat '$<')" \
		-nic "user,model=virtio-net-pci,hostfwd=tcp::2222-:22"

%/container.run: %/$(SYSTEM)
	sudo "$$(guix system $(LOAD_PATH) container --network '$<')"

%/image-docker.bin: %/$(SYSTEM)
	guix system $(LOAD_PATH) image --image-type=docker --network '$<' > '$@'

#%/image-docker.bin: %/$(SYSTEM)
#todo

%/image-small.bin: %/$(SYSTEM)
	guix system $(LOAD_PATH) image --image-type=qcow2 '$<' > '$@'
	#qemu-img convert?????
	#qemu-img resize '$<' +20G

%/image.bin: %/$(SYSTEM)
	guix system $(LOAD_PATH) image --image-size=20G --image-type=qcow2 '$<' > '$@'

%/image-temp.bin: %/image.bin
	mktemp > '$@'
	cp "$$(cat '$<')" "$$(cat '$@')"
	chmod +w "$$(cat '$@')"

#.PHONY: %/image.run
%/image.run: %/image-temp.bin
	. ./dev.env \
		&& qemu-system-x86_64 \
		-enable-kvm \
		-drive "file=$$(cat '$<'),format=qcow2" \
		-m 512 \
		-nic "user,model=virtio-net-pci,hostfwd=tcp::$$SSH_PORT-:22"

%/deploy: deploy.scm %/$(SYSTEM)
	SYSTEM='$*/$(SYSTEM)' guix deploy $(LOAD_PATH) '$<'
