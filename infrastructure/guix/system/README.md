# playbook

```
make base/deploy-image ENV_FILE=hot_desktop.env
```

```
#make your_system/deploy ENV_FILE=hot_desktop.env

# get ssh access via hypervisor
ssh -L 127.0.0.1:2222:cloudtest.lan.griffinht.com:22 hot-desktop.wg.griffinht.com
# deploy! make sure to edit deploy.scm with host key (and temp local address if you are remote and relying on ssh tunneling)
./guix.sh deploy podmanrootless/deploy.scm
```

# stuff

https://github.com/containers/podman/blob/main/docs/tutorials/basic_networking.md
https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md
https://opensource.com/article/19/2/how-does-rootless-podman-work
https://developers.redhat.com/blog/2020/09/25/rootless-containers-with-podman-the-basics#why_rootless_containers_
https://www.redhat.com/sysadmin/privileged-flag-container-engines

cgroups2
https://issues.guix.gnu.org/64260

/etc/subuid and more
https://www.mail-archive.com/guix-devel@gnu.org/msg67065.html



https://issues.guix.gnu.org/66160

# todo
socket activation - native network performance!
https://issues.guix.gnu.org/54811
https://github.com/containers/podman/blob/main/docs/tutorials/socket_activation.md#socket-activation-of-containers


# remote
https://docs.podman.io/en/latest/markdown/podman-remote.1.html


# todo use more scheme in configuration?? see if you can get by not using .env for config!

# can't connect?
icmp (ping) or udp (dig) seems to not work?
idk bruh!
