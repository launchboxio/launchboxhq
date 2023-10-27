---
sidebar_position: 3
---

# Installation

## Helm (All-in-One)

The all-in-one helm chart will install Launchbox, as well as all required dependencies to run on a bare Kubernetes cluster.
Depending on what services you're already running, you can disable them, and configure the `values.yaml` appropriately

```shell
helm upgrade --install launchbox launchboxhq/launchboxhq -n lbx-system
```

## Helm (Standalone)

If the required services already exist in your cluster, and / or you want to use managed services for them,
you can install just the LaunchboxHQ server

```shell
helm upgrade --install launchbox launchboxhq/launchboxhq-standalone -n lbx-system
```

## AIO Installer

We provider installers for the most Debian / Linux distributions

### Ubuntu
```shell
apt install launchboxhq
```

### CentOS
```shell
yum install launchboxhq
```

## Docker
```shell
docker run launcboxio/launchboxhq \
  --restart=always \
  --e DATABASE_URL=... \
  --e VAULT_ADDR=... \
  --e VAULT_TOKEN=... \
  --e OIDC_DOMAIN=... \
  -p 443:443
```
## Source
Really not recommended, but we'll document it at some point. Pretty much just `git clone && rails s`

## Tenancy

Users who wish to have a dedicated environment, but without hosting it themselves, are able to create a new tenant. This
is a unique deployment of Launchbox on separate infrastructure we managed, exclusive to your team.
