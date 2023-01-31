terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project     = "affable-skill-376404"
  region      = "us-west1"
}
