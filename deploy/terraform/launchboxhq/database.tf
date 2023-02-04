resource "google_sql_database_instance" "main" {
  name                = "launchboxhq-main"
  deletion_protection = false
  database_version    = "POSTGRES_14"
  region              = "us-east1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_redis_instance" "redis" {
  name                    = local.name
  memory_size_gb          = 1
  auth_enabled            = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"
}

resource "random_password" "password" {
  length = 32
}

resource "google_sql_user" "app" {
  name     = "application"
  instance = google_sql_database_instance.main.name
  password = random_password.password.result
}

resource "google_sql_database" "launchboxhq" {
  name     = "launchboxhq"
  instance = google_sql_database_instance.main.name
}

resource "kubernetes_namespace" "lbx-system" {
  metadata {
    name = "lbx-system"
  }

  depends_on = [
    google_container_cluster.primary
  ]
}

resource "kubernetes_secret" "credentials" {
  metadata {
    name = "launchboxhq"
    namespace = kubernetes_namespace.lbx-system.metadata[0].name
  }

  data = {
    DATABASE_URL = local.database_url
    REDIS_URL = local.redis_url
  }

  depends_on = [
    google_container_cluster.primary
  ]
}