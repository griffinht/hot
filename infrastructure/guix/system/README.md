# playbook

```
make base/deploy-image ENV_FILE=hot_desktop.env
```

1. virt-manager:
    - rename it to your own system
    - make sure networking is bridge br0, then probably restart
    - also set autoconnect and virtio share (See bottom) todo automate/iaac

```
error: Failed to create pool mystuff_pool
error: Failed to create file '/run/user/1000/libvirt/storage/run/mystuff_pool.xml.new': No such file or directory
```
start virtstoraged --daemon, just temporarily

3. dhcp:
    - configure mikrotik to hand out dhcp lease for vm's mac address
4. inital connection:
    - use ssh tunnel to hot-desktop.wg.griffinht.com or wireguard tunnel to lan to deploy! (or be on the local network)
        - note that sometimes i found that i had to make the vm do something like make an http request to the hypervisor before
        - debug: ip route get vm-host before and after applying this trick - maybe the hypervisor can't automatically add the route or something idk?
5. port forward any ports you want to the internet with mikrotik

```
#make your_system/deploy ENV_FILE=hot_desktop.env

# get ssh access via hypervisor
ssh -L 127.0.0.1:2222:cloudtest.lan.griffinht.com:22 hot-desktop.wg.griffinht.com
# deploy! make sure to edit deploy.scm with host key (and temp local address if you are remote and relying on ssh tunneling)
./guix.sh deploy podmanrootless/deploy.scm
```

## wireguard nmtui

add connection, wireguard

private key: `$(wg genkey)`
interface name: random
peer:
ipv4 config: manual, set to this ip address

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
ssh jumpbox
has docker cli installed, proxies unix socket to remote servers

socket activation - native network performance!
https://issues.guix.gnu.org/54811
https://github.com/containers/podman/blob/main/docs/tutorials/socket_activation.md#socket-activation-of-containers


# remote
https://docs.podman.io/en/latest/markdown/podman-remote.1.html


# todo use more scheme in configuration?? see if you can get by not using .env for config!

# can't connect?
icmp (ping) or udp (dig) seems to not work?
idk bruh!
