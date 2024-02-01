(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages containers)
             (gnu services networking)
             (gnu services ssh)
             (gnu services sysctl)
             (guix gexp)
             (griffinht system))

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
        nss-certs
        shadow ; newuidmap with setuid
        podman)
      %base-packages))
  (services
    (append
      (list (service dhcp-client-service-type)
            ; [rootlesskit:parent] error: failed to setup UID/GID map: failed to compute uid/gid map: open /etc/subuid: no such file or directory
            ; https://www.mail-archive.com/guix-devel@gnu.org/msg66974.html
            #|
            (simple-service
              'etc-subuid etc-service-type
              (list `("subuid" ,(plain-file "subuid"
                                  (string-append "docker:100000:65536\n")))))
            (simple-service
              'etc-subgid etc-service-type
              (list `("subgid" ,(plain-file "subgid"
                                  (string-append "docker:100000:65536\n")))))
            (service iptables-service-type
                     (iptables-configuration)))|#
      )
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
