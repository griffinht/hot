ssh podman@host vi .bashrc

https://docs.docker.com/engine/security/rootless/
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"

# todo
volumes vs custom containers?
nginx - live config, nice to have live changes i think??
invidious - basically a custom image builder
multi tenant db?

versioning! auto updates! deploy to staging/dev environment first! commit bot to change sha256!

backups! stateful services!

multi tenant s3
