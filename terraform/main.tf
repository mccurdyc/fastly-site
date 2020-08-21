terraform {
  required_version = ">= 0.13"

  backend "gcs" {
    bucket = "www-mccurdyc-dev-tfstate"
  }

  required_providers {
    fastly = {
      source  = "terraform-providers/fastly"
      version = "0.20.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "3.35.0"
    }

    google-beta = {
      source  = "hashicorp/google"
      version = "3.35.0"
    }
  }
}

provider "google" {
  credentials = file("account.json")
  project     = var.gcp_project_id
}

provider "google-beta" {
  credentials = file("account.json")
  project     = var.gcp_project_id
}

provider "fastly" {
  api_key = var.fastly_api_key
}

module "google-compute-platform" {
  source = "./modules/google-compute-platform"

  project_name        = var.gcp_project_name
  project_id          = var.gcp_project_id
  billing_account_id  = var.gcp_billing_account_id
  user_email          = var.gcp_user_email
  website_bucket_name = var.gcp_website_bucket_name
  logs_bucket_name    = var.gcp_logs_bucket_name
  root_domain         = var.root_domain
  asset_domain_prefix = var.asset_domain_prefix
  fastly_tls_host     = var.fastly_tls_host
  dns_txt_verify      = var.dns_txt_verify
}

module "fastly" {
  source = "./modules/fastly"

  service_name                  = var.fastly_service_name
  service_domain                = "${var.sub_domain}.${var.root_domain}"
  backend_origin_server_address = var.fastly_backend_origin_server_address
  backend_origin_server_name    = var.fastly_backend_origin_server_name
  cache_ttl_seconds             = var.fastly_cache_ttl_seconds
}
