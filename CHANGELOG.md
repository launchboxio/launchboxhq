# Changelog

All notable changes to this project will be documented in this file.

## [1.15.0](https://github.com/launchboxio/launchboxhq/compare/v1.14.3...v1.15.0) (2023-11-17)


### Features

* Import some branding ([65ee3db](https://github.com/launchboxio/launchboxhq/commit/65ee3dbc3045214eebec15bebe85be2461a30774))

### [1.14.3](https://github.com/launchboxio/launchboxhq/compare/v1.14.2...v1.14.3) (2023-11-17)


### Bug Fixes

* Move ActionMailer initialization ([b8e1bd0](https://github.com/launchboxio/launchboxhq/commit/b8e1bd08ff096251908d9f4587ee7583324b1086))

### [1.14.2](https://github.com/launchboxio/launchboxhq/compare/v1.14.1...v1.14.2) (2023-11-17)


### Bug Fixes

* Move action_mailer to application.rb ([42c6f54](https://github.com/launchboxio/launchboxhq/commit/42c6f54b7f75bc32b72e56d2c83d4d94a6d69933))

### [1.14.1](https://github.com/launchboxio/launchboxhq/compare/v1.14.0...v1.14.1) (2023-11-17)


### Bug Fixes

* require action_mailer ([884dcc6](https://github.com/launchboxio/launchboxhq/commit/884dcc60c24c645f197b0fb50f24691201184e32))

## [1.14.0](https://github.com/launchboxio/launchboxhq/compare/v1.13.2...v1.14.0) (2023-11-17)


### Features

* Add SendGrid configuration ([58f5b8c](https://github.com/launchboxio/launchboxhq/commit/58f5b8c301c1ae2a2fb61f62da6854e692ccc249))

### [1.13.2](https://github.com/launchboxio/launchboxhq/compare/v1.13.1...v1.13.2) (2023-11-16)


### Bug Fixes

* Broadcast just the product ID instead of building ([907c894](https://github.com/launchboxio/launchboxhq/commit/907c894e1b1e3ae0ccf81480b35984704676304c))

### [1.13.1](https://github.com/launchboxio/launchboxhq/compare/v1.13.0...v1.13.1) (2023-11-15)


### Bug Fixes

* Attach default version to addon response as well ([057c06f](https://github.com/launchboxio/launchboxhq/commit/057c06f6aa135f59edbc35c2720469d279a80169))

## [1.13.0](https://github.com/launchboxio/launchboxhq/compare/v1.12.2...v1.13.0) (2023-11-15)


### Features

* Add projects/:id/manifest for generating runtime ([fdcc67c](https://github.com/launchboxio/launchboxhq/commit/fdcc67c2ba6a7a94bfa574ec195d8fd28e32322d))

### [1.12.2](https://github.com/launchboxio/launchboxhq/compare/v1.12.1...v1.12.2) (2023-11-15)


### Bug Fixes

* Dont auto-login after password reset ([6ee6dc1](https://github.com/launchboxio/launchboxhq/commit/6ee6dc16032cb5ff2b2260612c4436013cb33151))

### [1.12.1](https://github.com/launchboxio/launchboxhq/compare/v1.12.0...v1.12.1) (2023-11-15)


### Bug Fixes

* Adjust styling and usage for password forms ([b94b178](https://github.com/launchboxio/launchboxhq/commit/b94b178b68de29d25f49aea7648a6af785383f18))

## [1.12.0](https://github.com/launchboxio/launchboxhq/compare/v1.11.0...v1.12.0) (2023-11-15)


### Features

* Add public endpoints for clusters and addons ([825cc9c](https://github.com/launchboxio/launchboxhq/commit/825cc9cfb0b66777d15655075d3df49d9a4e6323))

## [1.11.0](https://github.com/launchboxio/launchboxhq/compare/v1.10.4...v1.11.0) (2023-11-15)


### Features

* Add admin routes for users. Fix sign up / registration forms ([de702b9](https://github.com/launchboxio/launchboxhq/commit/de702b97af359654473a2ba4355daf24978fd979))
* Add admin routes for users. Fix sign up / registration forms ([66e15b2](https://github.com/launchboxio/launchboxhq/commit/66e15b27b514f4278468e5817ec81cb50e9e1d08))

### [1.10.4](https://github.com/launchboxio/launchboxhq/compare/v1.10.3...v1.10.4) (2023-11-14)


### Bug Fixes

* Use cluster association instead of lookup for broadcast ([af4d883](https://github.com/launchboxio/launchboxhq/commit/af4d88333f2dc78079d6e8f98d3e01230e42ddcb))

### [1.10.3](https://github.com/launchboxio/launchboxhq/compare/v1.10.2...v1.10.3) (2023-11-14)


### Bug Fixes

* Remove link for services and catalogs ([962be13](https://github.com/launchboxio/launchboxhq/commit/962be13c1ee7654930286eaebf27a5851d2d048c))
* Update link naming, stub out services panel ([09cf026](https://github.com/launchboxio/launchboxhq/commit/09cf0265b64a53dc309f1698e05f0bd7b3d51912))

### [1.10.2](https://github.com/launchboxio/launchboxhq/compare/v1.10.1...v1.10.2) (2023-11-14)


### Bug Fixes

* dont sample cluster if provided ([dd1c3be](https://github.com/launchboxio/launchboxhq/commit/dd1c3bec89cff815292c44239fa896edfa7bd372))

### [1.10.1](https://github.com/launchboxio/launchboxhq/compare/v1.10.0...v1.10.1) (2023-11-14)


### Bug Fixes

* clusters.update no longer double authorizes ([668856f](https://github.com/launchboxio/launchboxhq/commit/668856f874b6ef63b2a695feb34b3a194bec5705))

## [1.10.0](https://github.com/launchboxio/launchboxhq/compare/v1.9.0...v1.10.0) (2023-11-14)


### Features

* Allow selecting cluster ID when creating a project ([13b9182](https://github.com/launchboxio/launchboxhq/commit/13b9182491d475ad0c3c51656821d3dcea8ba93e))
* Allow setting of status on clusters ([c12249a](https://github.com/launchboxio/launchboxhq/commit/c12249a3ada28e901d614b0c9e667066ace4e217))

## [1.9.0](https://github.com/launchboxio/launchboxhq/compare/v1.8.7...v1.9.0) (2023-11-13)


### Features

* Add admin management of addon versions ([af341a0](https://github.com/launchboxio/launchboxhq/commit/af341a060a6cab0a1c3f8705bdb67f7f176c2dab))

### [1.8.7](https://github.com/launchboxio/launchboxhq/compare/v1.8.6...v1.8.7) (2023-11-13)


### Bug Fixes

* Include addon response for all addon subscription management ([49d5b5f](https://github.com/launchboxio/launchboxhq/commit/49d5b5f09a455c3090766ad3431a265c54a27e0c))

### [1.8.6](https://github.com/launchboxio/launchboxhq/compare/v1.8.5...v1.8.6) (2023-11-13)


### Bug Fixes

* Return addon configuration with API responses ([2865d47](https://github.com/launchboxio/launchboxhq/commit/2865d47605a1829d96357c5b3c52a5ae7290cbc7))

### [1.8.5](https://github.com/launchboxio/launchboxhq/compare/v1.8.4...v1.8.5) (2023-11-13)


### Bug Fixes

* Move file deletion until after final read ([541c8c7](https://github.com/launchboxio/launchboxhq/commit/541c8c718e7ee277b0dd8e767af362298270ddde))

### [1.8.4](https://github.com/launchboxio/launchboxhq/compare/v1.8.3...v1.8.4) (2023-11-13)


### Bug Fixes

* Dont delete tempfile manually ([f05d3cd](https://github.com/launchboxio/launchboxhq/commit/f05d3cd4e3daced2ea06b4acb71afd7fc2421477))

### [1.8.3](https://github.com/launchboxio/launchboxhq/compare/v1.8.2...v1.8.3) (2023-11-13)


### Bug Fixes

* Pass to token to other download function ([2b6fe46](https://github.com/launchboxio/launchboxhq/commit/2b6fe46aebf422248c2d02044b35378ae3c1aa68))

### [1.8.2](https://github.com/launchboxio/launchboxhq/compare/v1.8.1...v1.8.2) (2023-11-13)


### Bug Fixes

* Pass token to process_tarball for authentication ([c954dda](https://github.com/launchboxio/launchboxhq/commit/c954ddadb2d3a1ef97309aebdda143a9d5a841aa))

### [1.8.1](https://github.com/launchboxio/launchboxhq/compare/v1.8.0...v1.8.1) (2023-11-13)


### Bug Fixes

* Hoist repo variable ([098743d](https://github.com/launchboxio/launchboxhq/commit/098743dbe1be08e4548df70637ed6360096bda26))

## [1.8.0](https://github.com/launchboxio/launchboxhq/compare/v1.7.3...v1.8.0) (2023-11-13)


### Features

* Allow updating addon statuses ([5a58e58](https://github.com/launchboxio/launchboxhq/commit/5a58e580bbe962c3ee698027da948e3b4e1c22ba))

### [1.7.3](https://github.com/launchboxio/launchboxhq/compare/v1.7.2...v1.7.3) (2023-11-13)


### Bug Fixes

* Use addon_versions when emitting the event ([0536815](https://github.com/launchboxio/launchboxhq/commit/0536815dded0b6db4ed106809f887a622a795e1d))

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
