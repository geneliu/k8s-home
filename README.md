# Makima Cluster

Managed (hopefully) by Flux

## App structure

- default
    - [ ] Traefik (acts as a reverse proxy for everything else)
- observability
    - [ ] Grafana
    - [ ] Loki
    - [ ] InfluxDB
- media
    - [ ] rtorrent with Flood
    - [x] Sonarr
    - [ ] Radarr
    - [ ] Bazarr
    - [ ] Plex
    - [x] Jackett


## Folder structure

- `namespace_1`
    - `app`
        - `HelmRelease.yaml`
        - `PersistentVolume.yaml` (for persistence data per container)
    - `pvs` (for volumes needed for most containers in the namespace)
- `namespace_2`
    - ...
- `namespace_3`
    - ...
- `repositories`
    - `name_of_repo.yaml` (for Helm repositories)