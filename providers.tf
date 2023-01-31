terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project     = "sapient-magnet-376523"
  region      = "us-west1"
}
