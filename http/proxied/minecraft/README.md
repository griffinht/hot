# Minecraft Docker image
Extremely lightweight PurpurMC minecraft server with a `ttyd` web interface for `rcon-cli` for server administration.

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
