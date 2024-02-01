(use-modules (gnu packages ssh)
             (gnu packages certs)
             (gnu packages admin)
             (gnu packages docker)
             (gnu services base)
             (gnu services networking)
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
        dockerd-rootless.sh
        ; todo jumpbox
        docker-cli) ; for docker command for ssh access
      %base-packages))
  (services
    (append
      (list (service dhcp-client-service-type)
            (service openssh-service-type
                     (openssh-configuration
                      (openssh openssh-sans-x)
                      (permit-root-login `prohibit-password)
                      (password-authentication? #f)
                      (authorized-keys
                       `(("root" ,(local-file "../id_ed25519.pub"))
                         ("docker" ,(local-file "../id_ed25519.pub"))))))
            ; [rootlesskit:parent] error: failed to setup UID/GID map: failed to compute uid/gid map: open /etc/subuid: no such file or directory
            ; https://www.mail-archive.com/guix-devel@gnu.org/msg66974.html
            (simple-service
              'etc-subuid etc-service-type
              (list `("subuid" ,(plain-file "subuid"
                                  (string-append "docker:100000:65536\n")))))
            (simple-service
              'etc-subgid etc-service-type
              (list `("subgid" ,(plain-file "subgid"
                                  (string-append "docker:100000:65536\n")))))
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
