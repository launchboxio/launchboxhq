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

# Start Vault and Postgres
docker-compose up -d 

# Unseal Vault 
docker-compose exec vault sh 
vault operator init 
vault operator unseal

# Edit your .env file, replacing the Vault token
cp .env.example .env
vi .env

# Start rails 
rails db:create && rails db:migrate 
rails s
```


t4g.xlarge	$0.1344	4	16 GiB
m6g.xlarge	$0.154	4	16 GiB	EBS Only
c7g.xlarge	$0.1445	4	8 GiB	EBS Only