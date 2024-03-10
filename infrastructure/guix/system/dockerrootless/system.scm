(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages docker)
             (gnu services ssh)
             (gnu services sysctl)
             (guix gexp)
             (griffinht packages-bin docker)
             (griffinht system))

(operating-system
  (host-name "dockerrootless")
  (bootloader %vm-bootloader)
  (file-systems %vm-file-systems)
  (users
    (append
      (list
        (user-account
          (name "docker")
          (group "users")))))
  (packages
    (append
      (list
        nss-certs
        shadow ; newuidmap with setuid
        ;docker-cli ; needed for ssh but idk :/
        dockerd-rootless.sh)
      %base-packages))
  (services
    (append
      (list ; [rootlesskit:parent] error: failed to setup UID/GID map: failed to compute uid/gid map: open /etc/subuid: no such file or directory
            ; https://www.mail-archive.com/guix-devel@gnu.org/msg66974.html
            (%etc-subuid "docker")
            (%etc-subgid "docker")
            (service iptables-service-type
                     (iptables-configuration)))
      (modify-services
        %vm-services
        ;https://docs.docker.com/engine/security/rootless/#exposing-privileged-ports
        ;https://issues.guix.gnu.org/61462
        (sysctl-service-type
          config =>
          (sysctl-configuration
            (settings
              (append '(("net.ipv4.ip_unprivileged_port_start" . "0"))
                      %default-sysctl-settings))))))))
