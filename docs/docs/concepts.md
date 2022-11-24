---
sidebar_position: 2
---

# Concepts

### Cluster 

Clusters represent host Kubernetes clusters, where subsequent development spaces are deployed to. 
This can be the cluster LaunchboxHQ is deployed on, as well as other clusters that have been 
created or imported

### Space 

A space is an individual development environment. A single user may have many spaces at any given time, 
and users can have access to other users spaces 

### Cluster Addon 

These addons are installed at the cluster level. They encompass things such as 
 - Nginx Ingress  
 - Cluster Autoscaler 
 - Metrics Server 
 - Prometheus exporters / DataDog agents / etc 

They can be configured at the time of cluster creation, as well as applied to existing clusters. It is expected 
that each addon is only installed once on a given cluster

### Space Addon 

Services that are unique to the spaces running on a cluster can also be installed as addons. 
They can be installed multiple times per cluster if desired. They consist of services such as 
 - MySQL / Postgres 
 - Redis
 - Vault 

### Service Catalog 

Service Catalogs represent the business services that engineers are developing. They are most often tied to Git 
repositories, and are bundled for easy installation into new spaces 

### LaunchboxHQ 

The core server component, LaunchboxHQ handles user authentication / OIDC, cluster and space management, as well as 
integrations with other 3rd party providers. 

### Agent 

The agent runs on host Kubernetes clusters that are managed by LaunchboxHQ. They have permissions to manage resources on 
the host cluster, and receive GRPC commands from LaunchboxHQ to execute