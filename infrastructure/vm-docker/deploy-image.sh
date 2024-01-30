#!/bin/sh

# guix shell libvirt

#image="$1"
#image='/gnu/store/4bhpnz09gydwp62aw3mnknbzaiawfk3z-image.qcow2'
#backing_store="$image"

# add the disk as a libvirt disk image
# create the storage with it as the backing store

globals() {
    #libvirt_uri=qemu:///session
    #user=$USER
    user=libvirt
    ssh_uri=libvirt@hot-desktop.wg.griffinht.com
    libvirt_uri="qemu+ssh://$ssh_uri/session"
    prefix='mystuff'
}
globals

libvirt() {
    base="$1"
    shift

    command "$base" --connect "$libvirt_uri" "$@"
}

virsh() {
    libvirt virsh "$@"
}

virt_install() {
    libvirt virt-install "$@"
}

create_pool() {
    if ! virsh pool-info "$pool"; then
        pool_path="/home/$user/${prefix}_pool"
        if [ -n "$ssh_uri" ]; then
            ssh "$ssh_uri" mkdir -p "$pool_path"
        else
            mkdir -p "$pool_path"
        fi
        virsh pool-create-as "$pool" dir \
            --target "$pool_path"
        # todo
        #virsh pool-autostart "$pool"
    fi
}

print_xml() {
    name="$1"
    # todo specify network
    virt_install \
        --name "$name" \
        --disk \
            "pool=$pool,size=$size,backing_store=$backing_store" \
        --osinfo "$osinfo" \
        --print-xml
}

update() {
    # define new domain
    print_xml "${name}_new" \
        | virsh define /dev/stdin &
    pid_define="$!"

    # check if domain already exists
    state="$(virsh domstate "$name")" || already_exists=bruh
    if [ -z "$already_exists" ]; then
        # check if it is running
        # todo probably doesn't work if it is restarting or something idk
        if [ "$state" = "running" ]; then
            # shut it down
            virsh shutdown "$name"
            # allow old comain to shut down while we wait for new domain to be defined
            wait "$pid_define"
            # todo wait for shutdown
            virsh destroy "$name"
        else
            # old domain is not running, wait for new domain to be defined before undefining the old domain
            wait "$pid_define"
        fi

        # undefine it
        virsh undefine "$name"
    else
        # there is no old domain to remove, just wait for new domain to be defined
        wait "$pid_define"
    fi

    # rename new domain to the actual domain
    virsh domrename "${name}_new" "$name"

    # start it
    virsh start "$name"

    # todo clean up old volumes?
}

# todo run on remote? nah
get_size() {
    host_image="$host_image" python3 << EOF
import subprocess
import json
import math
import os

result = subprocess.run(["qemu-img", "info", os.getenv("host_image"), "--output=json"], capture_output=True)
if result.returncode != 0:
    print(result)
    exit(result.returncode)

size=json.loads(result.stdout)["virtual-size"]
print("{:.0f}".format(math.ceil(int(size) / (1024**3))))
EOF
}

copy_image() {
    # make sure image exists
    if ! ssh "$ssh_uri" ls "$target" > /dev/null; then
        echo copying image to host...
        scp "$host_image" "$ssh_uri:$target"
    fi
}

get_host_checksum() {
    (cd "$host_directory" && sha256sum "$image_name")
}

get_remote_checksum() {
    # todo rce??
    ssh "$ssh_uri" <<EOF
    set -xe
    mkdir -p "$remote_directory"
    cd "$remote_directory"
    sha256sum "$image_name"
EOF
}

main() {
    set -xe

    pool="${prefix}_pool"
    create_pool &
    pool_checksum="$!"

    if [ -n "$ssh_uri" ]; then
        remote_directory="/home/$user/$prefix"
        host_directory="$(dirname "$host_image")"
        image_name="$(basename "$host_image")"
        target="$remote_directory/$image_name"
        host_checksum_file="$(mktemp)"
        get_host_checksum > "$host_checksum_file" &
        pid_checksum="$!"

        if ! remote_checksum="$(get_remote_checksum)"; then
            kill "$pid_checksum"

            # image does not exist, copy it over (no need to verify integrity)
            copy_image
        else
            wait "$pid_checksum"

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

    wait "$pool_checksum"

    name="${prefix}_$basename"
    size="$(get_size)"
    backing_store="$image"
    osinfo="guix-latest"

    update
}

#host_image=$(cat image.bin)
#basename=testdockervm
host_image="$1"
basename="$2"
main
