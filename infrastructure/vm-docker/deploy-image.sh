#!/bin/sh

# requires libvirt, bc

#image="$1"
#image='/gnu/store/4bhpnz09gydwp62aw3mnknbzaiawfk3z-image.qcow2'
#backing_store="$image"

# add the disk as a libvirt disk image
# create the storage with it as the backing store

globals() {
    LIBVIRT_URI=qemu:///session
    PREFIX='mystuff_'
}
globals

libvirt() {
    base="$1"
    shift

    command "$base" --connect "$LIBVIRT_URI" "$@"
}

virsh() {
    libvirt virsh "$@"
}

virt_install() {
    libvirt virt-install "$@"
}

print_xml() {
    name="$1"
    # todo specify size?
    virt_install \
        --name "$name" \
        --disk \
            "size=$size,backing_store=$backing_store" \
        --osinfo "$osinfo" \
        --print-xml
}

update() {
    # define new domain
    print_xml "${name}_new" \
        | virsh define /dev/stdin

    # check if domain already exists
    state="$(virsh domstate "$name")"; exit_code="$?"
    if [ "$exit_code" -eq 0 ]; then
        # check if it is running
        # todo probably doesn't work if it is restarting or something idk
        if [ "$state" = "running" ]; then
            # shut it down
            virsh shutdown "$name"
            # todo wait for shutdown
            virsh destroy "$name"
        fi

        # undefine it
        virsh undefine "$name"
    fi

    # rename new domain to the actual domain
    virsh domrename "${name}_new" "$name"

    # start it
    virsh start "$name"

    # todo clean up old volumes?
}

get_size() {
    python3 << EOF
import subprocess
import json
import math

result = subprocess.run(["qemu-img", "info", "$image", "--output=json"], capture_output=True)
if result.returncode != 0:
    print(result)
    exit(result.returncode)

size=json.loads(result.stdout)["virtual-size"]
print("{:.0f}".format(math.ceil(int(size) / (1024**3))))
EOF
}

main() {
    set -x

    name="$PREFIX$basename"
    size="$(get_size)"
    backing_store="$image"
    osinfo="guix-latest"

    update
}

#image=$(cat image.bin)
#basename=bruhvm
image="$1"
basename="$2"
main
