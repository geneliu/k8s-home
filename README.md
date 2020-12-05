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
    - [x] qBitTorrent
    - [x] Sonarr
    - [ ] Radarr
    - [ ] Bazarr
    - [x] Plex
    - [x] Jackett


## Folder structure

- `namespace_1`
    - `_namespace.yaml`
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

## PV and PVC naming scheme

- For per-container PV: `[storage type]-[container name]-[usage]-[pv or pvc]`
    - Example: `nfs-plex-transcode-pvc`
- For per-namespace PV: `[storage type]-[usage]-[pv or pvc]`
    - Example: `nfs-media-pvc`