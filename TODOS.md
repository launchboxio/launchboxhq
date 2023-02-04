## Feature List

### Clusters

- [ ] [Admin] Support creating clusters using ClusterAPI
- [ ] [Admin] Support adding accounts from LaunchboxUI
- [ ] [Admin] Get shell to running cluster
- [ ] [Admin] Tagging mechanism for clusters

### Projects
- [ ] [Electron] Create project (vcluster) instances on demand
- [ ] [Electron / Admin] Configuration of Addons
- [ ] Support Addon Revisions
- [ ] Deploy specific revisions to specific clusters
- [ ] Automatic provisioning of addons using Crossplane
- [ ] Start / Stop scheduling (as well as 'managed' addons?) 
- [ ] OIDC access to cluster using Okta, Auth0, and others
- [ ] OIDC configuration set globally in admin 
- [ ] Replication / Migration of projects
- [ ] Allow multiple users access to a single project
- [ ] Automatically deploy services to new cluster based on tags
- [ ] Kubernetes API Endpoint available, valid TLS, and working
- [ ] Ability to create ingress routing to the cluster

### Git Integration
- [ ] Source services from git
- [ ] Automatically update when new main / version is created
- [ ] Auto-configuration from `.lbx.yaml` or similar file
- [ ] Auto Deploy templates to a cluster

### CI/CD
- [ ] Deployment of Tekton
- [ ] Ability to run test / validation jobs on Project
- [ ] Notification of job results
- [ ] Ephemeral environments: Deploy a group of services, spin up managed resources, run automated tests, and update Github
- [ ] Dogfood by using it to do account level provisioning for new projects

### Hosting 
- [ ] LaunchboxHQ SAAS 
- [ ] LaunchboxHQ SAAS - LB Control Plane / LB Organization
- [ ] LaunchboxHQ SAAS - LB Control Plane / Self Hosted Organization
- [ ] LaunchboxHQ Enterprise - Self Hosted Control Plane and Organization


