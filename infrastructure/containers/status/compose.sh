DOCKER_HOST=ssh://root@nerd-vps.wg.hot.griffinht.com docker compose --env-file=production.env -f compose.yml -f compose.production.yml "$@"
