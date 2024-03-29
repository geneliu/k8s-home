<img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" align="left" width="144px" height="144px"/>

# Home Cluster

Managed (hopefully) by [Flux](https://github.com/fluxcd/flux2)

## Requirements

- k3s
- a NFS client on k3s hosts
- a NFS host with some shares

## !!! IMPORTANT !!!

When using k3s, disable Traefik by editing `/etc/systemd/system/k3s.service`! Here is a quick snippet for you (and me).

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -
```

## Installation

### Generate secrets

0. Install dependencies: `jq` and `kubeseal`
1. Go to the `configs/values` and `configs/unsealed-secrets` folders and remove the `.example` suffix at the ends of files. Then, replace the data inside those files.
2. Run the following commands from the `configs` folder:

```sh
    chmod +x ./generateSecret.sh
    ./generateSecret.sh <name of the app>
```

### Install cluster

```sh
# Bootstrap the repository with Flux v2
$ flux bootstrap github --verbose \
  --owner=zbigniewzolnierowicz \
  --repository=k8s-home \
  --branch=main \
  --path=cluster \
  --personal
```

For why you need the second command, see [this issue](https://github.com/fluxcd/flux2/issues/562#issuecomment-740014295).

## App structure

- default
    - [x] Traefik (acts as a reverse proxy for everything else)
    - [ ] Blocky
    - [ ] cert-manager
    - [ ] Dex
- observability
    - [ ] Grafana
    - [ ] Loki
    - [ ] Prometheus
    - [ ] speedtest-prometheus
- media
    - [x] qBitTorrent
    - [x] Sonarr
    - [x] Radarr
    - [x] Bazarr
    - [x] Plex
    - [x] Jackett
- games
    - [ ] minecraft
- flux-system
    - [x] OpenEBS with Local PV Hostpath
- programming
    - [x] Gitea
    - [ ] Jenkins

## Folder structure

- `cluster`
    - `default`
        - `traefik`
            - `routes`
                - `AppName.yaml`
                - `kustomization.yaml` (add every route declared by `AppName.yaml` here)
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
- `configs`
    - `values`
        - `appname.yaml`
    - `unsealed-secrets`
    - `mapping.json`

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
