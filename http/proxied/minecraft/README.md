# Minecraft Docker image
Extremely lightweight PurpurMC minecraft server with a `ttyd` web interface for `rcon-cli` for server administration.

## Configuration
Docker is used

### Volumes
- `/minecraft`

### Ports
- `25565` (should be exposed)
- `80` (should not be exposed, used for `ttyd` web interface for `rcon-cli`)

### Environment variables
- `WEB`
    - default unset
    - set to blank or any value to start the `ttyd` web interface for `rcon-cli`
- `WEB_BASE_PATH`
    - default `/`
    - used for putting the web interface behind a reverse proxy
- `WEB_PORT`
    - default `80`
    - port for web interface
    
## Installation

### Start
```
docker compose up
```

### Administration
Use the web interface or `docker exec -it $(docker ps -qf name=minecraft) rcon-cli`

Add plugins and configure the server through the /minecraft volume

### Stop
```
docker compose stop
```

Make sure `stop_grace_period` is set to something like `60s` to provide enough time for the server to stop when the container is stopped gracefully.
