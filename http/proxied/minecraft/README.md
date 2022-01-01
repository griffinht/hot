```
docker compose up
```

```
docker exec -it $(docker ps | grep minecraft_minecraft | cut -c -12) rcon-cli
```