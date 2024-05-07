(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages docker)
             (gnu packages containers)
             (gnu services ssh)
             (gnu services sysctl)
             (guix gexp)
             (griffinht system)
             (griffinht packages misc))

(define ssh-pubkey
  (local-file "../cool-laptop.pub"))

(operating-system
  (host-name "podmanrootless")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (users
    (append
      (list
        (user-account
          (name "podman")
          (group "users")))))
  (packages
    (append
      (list
        shadow ; newuidmap with setuid
        ; things that (probably) don't need to be installed root (setuid)
        podman
        ; griffinht packages misc
        ; https://issues.guix.gnu.org/66887
        ; required by podman to build init container for pods
        catatonit
        ;iptables
        ;iptables-nft
        ;nftables
        docker-cli)
      %vm-packages))
  (services
    (append
      (list ; [rootlesskit:parent] error: failed to setup UID/GID map: failed to compute uid/gid map: open /etc/subuid: no such file or directory
            ; https://www.mail-archive.com/guix-devel@gnu.org/msg66974.html
            (etc-subuid "podman")
            (etc-subgid "podman")
            (simple-service 'etc-container-policy etc-service-type
                        (list `("containers/policy.json", (local-file "policy.json")))))
      (modify-services
        (make-vm-services `(("root" ,ssh-pubkey) ("podman" ,ssh-pubkey)))
        ;https://docs.docker.com/engine/security/rootless/#exposing-privileged-ports
        ;https://issues.guix.gnu.org/61462
        (sysctl-service-type
          config =>
          (sysctl-configuration
            (settings
              (append '(("net.ipv4.ip_unprivileged_port_start" . "0"))
                      %default-sysctl-settings))))))))
