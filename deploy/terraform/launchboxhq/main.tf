terraform {
  required_version = "1.3.7"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.49.0"
    }
  }
}

provider "google" {
  project = "launchboxhq"
  region  = "us-east1"
}
