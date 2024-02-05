.SECONDARY:
.DELETE_ON_ERROR:

SYSTEM=system.scm
LOAD_PATH=--load-path=channel
SSH_KEY=id_ed25519.bin
DEPLOY_IMAGE_SCRIPT=./scripts/deploy-image.sh
ENV_FILE=local.env
ENV_SCRIPT=. ./$(ENV_FILE) &&

id_%.bin:
	ssh-keygen -t $* -f '$@' -N ""
	mv '$@.pub' 'id_$*.pub.bin'

# debug thing, todo use make for this idk
load:
	$(ENV_SCRIPT) echo '(use-modules (griffinht system) (griffinht deploy))' | guix repl $(LOAD_PATH)

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
	$(ENV_SCRIPT) guix system $(LOAD_PATH) vm --no-graphic '$<' > '$@'

%/vm.run: %/vm.bin
	"$$(cat '$<')" \
		-nic "user,model=virtio-net-pci,hostfwd=tcp::2222-:22"

%/container.run: %/$(SYSTEM)
	sudo "$$($(ENV_SCRIPT) guix system $(LOAD_PATH) container --network '$<')"

%/image-docker.bin: %/$(SYSTEM)
	$(ENV_SCRIPT) guix system $(LOAD_PATH) image --image-type=docker --network '$<' > '$@'

#%/image-docker.bin: %/$(SYSTEM)
#todo

%/image-small.bin: %/$(SYSTEM)
	$(ENV_SCRIPT) guix system $(LOAD_PATH) image --image-type=qcow2 '$<' > '$@'
	#qemu-img convert?????
	#qemu-img resize '$<' +20G

%/image.bin: %/$(SYSTEM)
	$(ENV_SCRIPT) guix system $(LOAD_PATH) image --image-size=20G --image-type=qcow2 '$<' > '$@'

%/image-temp.bin: %/image.bin
	mktemp > '$@'
	cp "$$(cat '$<')" "$$(cat '$@')"
	chmod +w "$$(cat '$@')"

#.PHONY: %/image.run
%/image.run: %/image-temp.bin
	qemu-system-x86_64 \
		-enable-kvm \
		-drive "file=$$(cat '$<'),format=qcow2" \
		-m 512 \
		-nic "user,model=virtio-net-pci,hostfwd=tcp::2222-:22"

%/deploy: deploy.scm %/$(SYSTEM)
	$(ENV_SCRIPT) SYSTEM='$*/$(SYSTEM)' guix deploy $(LOAD_PATH) '$<'

%/deploy-image: %/image.bin $(DEPLOY_IMAGE_SCRIPT)
	$(ENV_SCRIPT) guix shell libvirt -- './$(DEPLOY_IMAGE_SCRIPT)' "$$(cat '$<')" '$*'

bruh:
	make base/deploy-image
	# todo wait for ssh
	sleep 15
	# https://blog.adamspiers.org/2012/01/23/port-redirection-from-kvm-host-to-guest/
	# todo specify local? it should be implict
	virsh qemu-monitor-command --hmp mystuff_base 'hostfwd_add ::2222-:22'
	make guix/deploy
