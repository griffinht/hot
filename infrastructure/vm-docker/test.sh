#!/bin/sh

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

third() {
    ssh_key_file="$1"
    vm_script="$2"

    lssh() {
        ssh -i "$ssh_key_file" -p "$SSH_PORT" "$HOST" "$@"
    }

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

second() {
    ssh_key_file="$1"

    vm_script="$(make_vm_script)"
    pidfile="$(mktemp)"
    "$vm_script" \
        -nic "user,model=virtio-net-pci,hostfwd=tcp::$SSH_PORT-:22,hostfwd=udp::$WIREGUARD_PORT-:$WIREGUARD_PORT" \
        -daemonize \
        -pidfile "$pidfile"

    # allow vm to start
    # todo repeatedly loop ssh instead
    #sleep 5

    third "$ssh_key_file" "$vm_script"
    code="$?"

    xargs kill < "$pidfile"

    return "$code"
}

main() {
    interface="$1"
    test_address="$
    wg_key="$(wg genkey)"
    ssh_key_file="$(mktemp)"

    ssh-keygen -t ed25519 -N '' -f "$ssh_key_file"

    second "$ssh_key_file"
    code="$?"

    return "$code"
}

main todo
exit "$?"
