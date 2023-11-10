# Changelog

All notable changes to this project will be documented in this file.

### [1.7.2](https://github.com/launchboxio/launchboxhq/compare/v1.7.1...v1.7.2) (2023-11-10)


### Bug Fixes

* Return data object, not map output ([21ad848](https://github.com/launchboxio/launchboxhq/commit/21ad848d7eb2f228fa987c571a5748cc8f4dda2a))

### [1.7.1](https://github.com/launchboxio/launchboxhq/compare/v1.7.0...v1.7.1) (2023-11-10)


### Bug Fixes

* Compile addon payload when emitting events ([c9d0c1a](https://github.com/launchboxio/launchboxhq/commit/c9d0c1a99833ebad0d5534ca2e801f9f52f8409e))

## [1.7.0](https://github.com/launchboxio/launchboxhq/compare/v1.6.0...v1.7.0) (2023-11-10)


### Features

* Refactor project addons and subscriptions ([9c60ed6](https://github.com/launchboxio/launchboxhq/commit/9c60ed6461c8e052dd2498de1d2781e411548794))


### Bug Fixes

* Move ClusterSyncJob to Sidekiq ([99f3b3c](https://github.com/launchboxio/launchboxhq/commit/99f3b3c619be946eb497da54476d7fcef5c4bfcb))

## [1.6.0](https://github.com/launchboxio/launchboxhq/compare/v1.5.0...v1.6.0) (2023-11-09)


### Features

* Add job for resyncing clusters w/ projects and addons ([f70dc28](https://github.com/launchboxio/launchboxhq/commit/f70dc288da9c97a0c4f9b400871c89e9c8b20e57))

## [1.5.0](https://github.com/launchboxio/launchboxhq/compare/v1.4.0...v1.5.0) (2023-11-09)


### Features

* Move addon operations to services ([5c1f6ba](https://github.com/launchboxio/launchboxhq/commit/5c1f6bad3dd30bf376d928c0af191caa753feff6))

## [1.4.0](https://github.com/launchboxio/launchboxhq/compare/v1.3.0...v1.4.0) (2023-11-09)


### Features

* Add domain setting to clusters ([6c12c4a](https://github.com/launchboxio/launchboxhq/commit/6c12c4a43e3d75adfa92a73dc994c9b913f9df1c))


### Bug Fixes

* Adjust login form ([dd6b7ab](https://github.com/launchboxio/launchboxhq/commit/dd6b7abafda6fc2365f2dd098786dc74c2e625c9))
* **auth:** Redirect to login page, and back to /projects ([75f61f8](https://github.com/launchboxio/launchboxhq/commit/75f61f855e2e6f59d2fc308d48c4a34a5788421d))

## [1.3.0](https://github.com/launchboxio/launchboxhq/compare/v1.2.1...v1.3.0) (2023-11-09)


### Features

* Add Kubernetes version to project creation ([bd56983](https://github.com/launchboxio/launchboxhq/commit/bd56983f1bc1adbe0783f5834b702038dd86d696))


### Bug Fixes

* Update Kubernetes versions, add selected version to both index / show pages ([7c93a09](https://github.com/launchboxio/launchboxhq/commit/7c93a09cf9b80d39f99cd9030ea1da530b169594))

### [1.2.1](https://github.com/launchboxio/launchboxhq/compare/v1.2.0...v1.2.1) (2023-11-09)


### Bug Fixes

* Prefix generated domains with api. ([640e883](https://github.com/launchboxio/launchboxhq/commit/640e883c5f0a77de447986a0706486fdce37b4e0))

## [1.2.0](https://github.com/launchboxio/launchboxhq/compare/v1.1.3...v1.2.0) (2023-11-09)


### Features

* Configurable domain when generating a cluster ([e5d27e1](https://github.com/launchboxio/launchboxhq/commit/e5d27e16f0548077a0e70f147a8cf58d0700965a))

### [1.1.3](https://github.com/launchboxio/launchboxhq/compare/v1.1.2...v1.1.3) (2023-11-09)


### Bug Fixes

* Add FQDN for project to status page ([32d68dd](https://github.com/launchboxio/launchboxhq/commit/32d68ddd40357f648aab0e9bcf14f718ffa7c7ab))
* Disable usage of managed clusters for now ([d2944e8](https://github.com/launchboxio/launchboxhq/commit/d2944e899ede3bde467af10570982b63704a4be3))
* Return clsuter model on update success ([90146bd](https://github.com/launchboxio/launchboxhq/commit/90146bd1e38dc330ab0b3a8f870cdf07ec99c246))

### [1.1.2](https://github.com/launchboxio/launchboxhq/compare/v1.1.1...v1.1.2) (2023-11-08)


### Bug Fixes

* Add status badging for projects ([3360368](https://github.com/launchboxio/launchboxhq/commit/3360368df7feb97b4f3efe95103e53bdccc0af38))

### [1.1.1](https://github.com/launchboxio/launchboxhq/compare/v1.1.0...v1.1.1) (2023-11-08)


### Bug Fixes

* **clusters:** Add oauth application info to admin responses ([b1a1104](https://github.com/launchboxio/launchboxhq/commit/b1a11041ac20c6a706d6ba9e3d0480c845bd5fe1))

## [1.1.0](https://github.com/launchboxio/launchboxhq/compare/v1.0.0...v1.1.0) (2023-11-08)


### Features

* **db:** Cleanup database migrations. Add indices and defaults ([2e8764c](https://github.com/launchboxio/launchboxhq/commit/2e8764cac26fbae97b11483abd944fb5f889ad8b))

## 1.0.0 (2023-11-07)


### Bug Fixes

* **ci:** Remove docs directory, add semantic-release ([b0cd5c7](https://github.com/launchboxio/launchboxhq/commit/b0cd5c7b60b6cd9336853f4cc3902b306fe0f649))
