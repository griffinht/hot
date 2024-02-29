#!/bin/sh

# needs socat

set -e



globals() {
    HOST=localhost
    SSH_PORT=2222
    WIREGUARD_PORT=51820
}
globals


make_vm_script() {
    test_ssh_pubkey="$(ssh-keygen -y -f "$ssh_key_file")" \
        test_wg_pubkey="$(echo "$wg_key" | wg pubkey)" \
        guix system vm "test.scm"
}

poll() {
    delay=1
    timeout="$1"
    shift

    for i in $(seq 1 "$timeout"); do
        echo "polling ($i/$timeout):" "$@"
        if "$@"; then
            return 0
        fi
        echo "failed with code $?, retrying in $delay seconds..."
        sleep $delay
    done

    return 1
}

lssh() {
    ssh -i "$ssh_key_file" -p "$ssh_port" localhost "$@"
}

wait_for_ssh() {
    echo waiting for ssh connectivity...
    # only needs 1 since the port blocks instantly
    if ! poll 2 lssh w; then
        echo system did not respond to ssh before timeout, killing...
        kill "$(cat "$pidfile")"
        return 1
    fi
}

test_acpi() {
    ssh_port=1345
    socket="$(mktemp)"
    pidfile="$(mktemp)"
    "$vm_script" \
        -nic "user,model=virtio-net-pci,hostfwd=tcp::$ssh_port-:22" \
        -daemonize \
        -pidfile "$pidfile" \
        -monitor "unix:$socket,server=on,wait=off"
    wait_for_ssh || return "$?"

    echo issuing powerdown command to qemu...
    echo "system_powerdown" | socat - "unix-connect:$socket"

    echo waiting for powerdown...
    if ! poll 6 sh -c "! kill -0 $(cat "$pidfile")"; then
        echo system did not powerdown before timeout, killing...
        kill "$(cat "$pidfile")"
        #xargs kill < "$pidfile"
        return 1
    fi

    echo system powered down nicely
}

test_wg_forreal() {
    peer_wg_pubkey="$(lssh wg show wg0 public-key)"

    wg_conf_file="$(mktemp).conf"
    chmod 600 "$wg_conf_file" # suppress wg-quick warning about how the file is world accessible
    cat > "$wg_conf_file" << EOF
[Interface]
PrivateKey=$wg_key
Address=10.0.0.4

[Peer]
PublicKey=$peer_wg_pubkey
Endpoint=127.0.0.1:$WIREGUARD_PORT
AllowedIPs=10.0.0.0/24, 152.0.0.0/24
EOF
    
    #sudo $(which wg-quick) up "$wg_conf_file"
    #curl 152.7.78.105:8000
    #sudo $(which wg-quick) down "$wg_conf_file"
}

test_wg() {
    pidfile="$(mktemp)"
    ssh_port=2224
    "$vm_script" \
        -nic "user,model=virtio-net-pci,hostfwd=tcp::$ssh_port-:22,hostfwd=udp::$WIREGUARD_PORT-:$WIREGUARD_PORT" \
        -daemonize \
        -pidfile "$pidfile"
    wait_for_ssh || return "$?"

    test_wg_forreal
    code="$?"

    xargs kill < "$pidfile"

    return "$code"
}

init() {
    wg_key="$(wg genkey)"
    ssh_key_file="$(mktemp -u)"
    ssh-keygen -t ed25519 -N '' -f "$ssh_key_file"
    vm_script="$(make_vm_script)"
}

bruh() {
    init
    test_wg
    test_acpi
}

bruh
main todo
exit "$?"

