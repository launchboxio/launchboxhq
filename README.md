# LaunchboxHQ


## Installation

### Helm

## Development

TODO: Maybe move to `bin/setup`

```shell
# Clone the repository
git clone git@github.com:launchboxio/launchboxhq

# Generate a signing key for OIDC requests
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
kubectl create secret generic signing-certificate --from-file=private_key.pem -n lbx-system
# Start Vault and Postgres
docker-compose up -d

# Unseal Vault
docker-compose exec vault sh
vault operator init -n 1 -t 1
vault operator unseal
vault secrets enable transit

# Edit your .env file, replacing the Vault token
cp .env.example .env
vi .env

# Start rails
rails db:create && rails db:migrate
rails s
```

# Generate the Kubernetes cluster authentication client
```shell
rails c
Doorkeeper::Application.create(name: "Cluster Authentication", redirect_uri: "http://localhost:8080")
```

## Kubeconfig template
To connect to kubernetes using the OIDC provided by Launchbox

kubectl oidc-login get-token --oidc-issuer-url http://localhost:3000 --oidc-client-id=RSR00W3ZNJnlc2uPKBE7dx7zDwq_ZTlbeU7sqPkfrbk --oidc-extra-scope email -v8
```yaml
user:
- name: <%= current_user.email %>
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - oidc-login
      - get-token
      - --oidc-issuer-url=<%= @client.uid %>
      - --oidc-client-id=<%= @domain %>
      - --oidc-extra-scope=email
      command: kubectl
      env: null
      interactiveMode: IfAvailable
      provideClusterInfo: false
```
