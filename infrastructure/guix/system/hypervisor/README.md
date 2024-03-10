https://blog.wikichoon.com/2016/01/qemusystem-vs-qemusession.html








https://guix.gnu.org/manual/devel/en/html_node/Invoking-guix-deploy.html

make sure the host machine's guix archive has already generated a key before deploying
if not, then run this command on the host machine

```
sudo guix archive --generate-key
```
https://stumbles.id.au/getting-started-with-guix-deploy.html
https://www.thedroneely.com/posts/guix-in-a-linux-container/


better variable templating! scheme include variable from other file! or something idk
just use (define %system with args)


BARE METAL DEPLOY
manually install guix system
manually copy disk/bootloader config to system.scm
guix deploy!

todo use podman!
https://docs.podman.io/en/latest/markdown/podman-system-service.1.html

todo unit tests?
    fastest deployment method
    test ssh login with correct and incorrect keys
    test users exist





# TODO
monitoring
https://github.com/MindFlavor/prometheus_wireguard_exporter

ci
https://guix.gnu.org/manual/en/html_node/Continuous-Integration.html

samba
https://guix.gnu.org/manual/en/html_node/Samba-Services.html

nfs
https://alexdelorenzo.dev/linux/2020/01/28/nfs-over-wireguard.html
