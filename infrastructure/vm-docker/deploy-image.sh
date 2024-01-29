#!/bin/sh

# guix shell libvirt

#image="$1"
#image='/gnu/store/4bhpnz09gydwp62aw3mnknbzaiawfk3z-image.qcow2'
#backing_store="$image"

# add the disk as a libvirt disk image
# create the storage with it as the backing store

globals() {
    #LIBVIRT_URI=qemu:///session
    SSH=libvirt@hot-desktop.wg.griffinht.com
    LIBVIRT_URI="qemu+ssh://$SSH/session"
    PREFIX='mystuff'
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
    print_xml "${name}_new"
    exit 1
        #| virsh define /dev/stdin

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

# todo run on remote? nah
get_size() {
    python3 << EOF
import subprocess
import json
import math

result = subprocess.run(["qemu-img", "info", "$host_image", "--output=json"], capture_output=True)
if result.returncode != 0:
    print(result)
    exit(result.returncode)

size=json.loads(result.stdout)["virtual-size"]
print("{:.0f}".format(math.ceil(int(size) / (1024**3))))
EOF
}

copy_image() {
    # make sure image exists
    if ! ssh "$SSH" ls "$target" > /dev/null; then
        echo copying image to host...
        scp "$host_image" "$SSH:$target"
    fi
}

get_host_checksum() {
    (cd "$host_directory" && sha256sum "$image_name")
}

get_remote_checksum() {
    ssh "$SSH" <<EOF
    set -xe
    mkdir -p "$remote_directory"
    cd "$remote_directory"
    sha256sum "$image_name"
EOF
}

main() {
    set -xe

    if [ -n "$SSH" ]; then
        remote_directory="/home/libvirt/$PREFIX"
        host_directory="$(dirname "$host_image")"
        image_name="$(basename "$host_image")"
        target="$remote_directory/$image_name"
        host_checksum_file="$(mktemp)"
        get_host_checksum > "$host_checksum_file" &
        pidA="$!"

        if ! remote_checksum="$(get_remote_checksum)"; then
            kill "$pidA"

            # image does not exist, copy it over (no need to verify integrity)
            copy_image
        else
            wait "$pidA"

            # image exists, verify integrity
            if [ "$(cat "$host_checksum_file")" != "$remote_checksum" ]; then
                echo 'checksums do not match'
                return 1
            fi
        fi

        image="$target"
    else
        image="$host_image"
    fi

    name="${PREFIX}_$basename"
    size="$(get_size)"
    backing_store="$image"
    osinfo="guix-latest"

    update
}

#host_image=$(cat image.bin)
#basename=bruhvm
host_image="$1"
basename="$2"
main
