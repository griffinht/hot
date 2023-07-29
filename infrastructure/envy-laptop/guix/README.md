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
