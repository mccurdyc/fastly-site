terraform {
  backend "gcs" {
    bucket = "www-mccurdyc-dev-tfstate"
  }

  required_providers {
    fastly = {
      source  = "terraform-providers/fastly"
      version = "~> 1.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 4.11"
    }

    google-beta = {
      source  = "hashicorp/google"
      version = "~> 4.11"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
}

provider "google-beta" {
  project = var.gcp_project_id
}

provider "fastly" {
  # FASTLY_API_KEY environment variable
}

