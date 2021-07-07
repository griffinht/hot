### Setup
  - Navigate to `config/config.xml`
  - Set `<UrlBase></UrlBase>` to `<UrlBase>/radarr</UrlBase>`
  - Restart Radarr
  - Navigate to http://localhost/radarr
  - Configure

### Configuration
  - Settings
    - Media Management
      - See https://trash-guides.info/Radarr/Radarr-recommended-naming-scheme/
    - Quality
      - See https://trash-guides.info/Radarr/Radarr-Quality-Settings-File-Size/
    - Indexers
      - Torznab: Custom
        - Name: `Jackett`
        - URL: `http://localhost:9117`
        - API Path: `/torznab/all/api`
        - API Key: See Jackett
      - Download Clients
        - qBittorrent
          - Name: `qBittorrent`
          - Host: `localhost`
          - Port: `8080`
          - Username: 
          - Password: 
