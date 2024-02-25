# mikrotik
api endpoint for interacting with router/keeping it updated? via ssh probably
```
POST update-ip
<new-ip>
```
```
GET ssh
(returns ssh credentials for manual management)
```
### depends
- a physical mikrotik router


# guix router
https://timmydouglas.com/2021/02/07/guix-router.html
https://francis.begyn.be/blog/nixos-home-router



# ssh
routeros 7 might have perf issues
routeros 6 only supports rsa :(
anyways:

1. generate rsa key
ssh-keygen -t rsa
    (use 4096 bit key)

2. copy to mikrotik
    there are a variety of ways to do this

3. /user ssh-keys import public-key-file=id_rsa.pub user=admin
    note that password auth will be disabled at this point!

4. ssh -o PubkeyAcceptedAlgorithms=+ssh-rsa admin@mikrotik
    :(
    https://forum.mikrotik.com/viewtopic.php?t=185635
