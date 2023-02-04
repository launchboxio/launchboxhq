locals {
  project = "launchboxhq"
  region  = "us-east1"
  name    = "launchboxhq-${random_string.cluster.result}"
  zones   = ["us-east1-a", "us-east1-b", "us-east1-f"]

  database_url = "postgresql://${google_sql_user.app.name}:${google_sql_user.app.password}@${google_sql_database_instance.main.ip_address.0.ip_address}:5432/${google_sql_database.launchboxhq.name}"
  redis_url = "rediss://:${google_redis_instance.redis.auth_string}@${google_redis_instance.redis.host}:6379"
}

resource "random_string" "cluster" {
  length  = 8
  special = false
  numeric = false
  upper   = false
}