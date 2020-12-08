<img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" align="left" width="144px" height="144px"/>

# Home Cluster

Managed (hopefully) by [Flux](https://github.com/fluxcd/flux2)

## Installation

```sh
# First, bootstrap the repository with Flux v2
$ flux bootstrap github --verbose \
  --owner=zbigniewzolnierowicz \
  --repository=k8s-home \
  --branch=main \
  --path=cluster \
  --personal
# Then, add the routes for Traefik
$ kubectl apply \
    -f ./routes/plex/Plex.yaml \
    -f ./routes/qbittorrent/qBitTorrent.yaml \
    -f ./routes/traefik/Dashboard.yaml
```

For why you need the second command, see [this issue](https://github.com/fluxcd/flux2/issues/562#issuecomment-740014295).

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
    - [x] Radarr
    - [ ] Bazarr
    - [x] Plex
    - [x] Jackett
- games
    - [ ] minecraft
- flux-system
    - [ ] OpenEBS with Local PV Hostpath


## Folder structure

- `cluster`
    - `namespace_1`
        - `_namespace.yaml`
        - `app`
            - `HelmRelease.yaml`
            - `PersistentVolume.yaml` (for persistence data per container)
            - `CustomResourceDefinition.yaml`
        - `pvs` (for volumes needed for most containers in the namespace)
    - `namespace_2`
        - ...
    - `namespace_3`
        - ...
    - `repositories`
        - `name_of_repo.yaml` (for Helm repositories)
- `routes`
    - `app`
        - `NameOfRoute.yaml`

## PV and PVC naming scheme

- For per-container PV: `[storage type]-[container name]-[usage]-[pv or pvc]`
    - Example: `nfs-plex-transcode-pvc`
- For per-namespace PV: `[storage type]-[usage]-[pv or pvc]`
    - Example: `nfs-media-pvc`

## Inspirations and people that helped me get this set up

- [k8s-at-home/awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes)
- [fluxcd/flux2](https://github.com/fluxcd/flux2)
- [onedr0p/home-cluster](https://github.com/onedr0p/home-cluster)
- [anthr76/infra](https://github.com/anthr76/infra)
