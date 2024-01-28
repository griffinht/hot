#/bin/sh

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

virsh() {
    command virsh --connect "$LIBVIRT_URI" "$@"
}

# pools
pool_deploy() {
    local pool="$1"

    virsh \
        pool-define-as "$pool" dir \
            --target "$pool_path"
    mkdir -p "$pool_path"
    #virsh \
    #    pool-start "$pool"
}


print-xml() {
    virt-install --connect "$LIBVIRT_URI" \
        --name "$name" \
        --disk \
            size="33",backing_store="$backing_store" \
        --osinfo "$osinfo" \
        --print-xml
}

update() {
    # check if domain already exists
    state="$(virsh domstate "$name" || true)"
    if [ "$?" -eq 0 ]; then
        # check if it is running
        # todo doesn't work if it is restarting or something idk
        if [ "$state" == "running" ]; then
            # shut it down
            virsh shutdown "$name"
            # todo wait for shutdown
            virsh destroy "$name"
        fi

        # undefine it
        virsh undefine "$name"
    fi

    # define it
    print-xml "$name" "$backing_store" "$osinfo" \
        | virsh define /dev/stdin

    # start it
    virsh start "$name"

    # todo clean up old volumes?
}

main() {
    set -xe

    name="$PREFIX$1"
    backing_store="$(guix system image bootstrap.scm \
        --image-type=qcow2 \
        --image-size=20G)" || exit_code="$?"
    if [ -n "$exit_code" ]; then
        echo "command failed with $exit_code"
        exit "1"
    fi
    osinfo="guix-latest"

    #make bruh
    update "$name" "$backing_store" "$osinfo"
}

main bruhvm
