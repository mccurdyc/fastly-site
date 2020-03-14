terraform {
  # The modules used in this example have been updated with 0.12 syntax, which means the example is no longer
  # compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

provider "google" {
  version = "~> 3.9.0"
  project = var.gcp_project_name
}

provider "google-beta" {
  version = "~> 3.11.0"
  project = var.gcp_project_name
}

provider "fastly" {
  version = "~> 0.12"
  api_key = var.fastly_api_key
}

module "google-compute-platform" {
  source = "./modules/google-compute-platform"

  project_name        = var.gcp_project_name
  billing_account_id  = var.gcp_billing_account_id
  user_email          = var.gcp_user_email
  website_bucket_name = var.gcp_website_bucket_name
  root_domain         = var.root_domain
  asset_domain_prefix = var.asset_domain_prefix
}

module "fastly" {
  source = "./modules/fastly"

  service_name                  = var.fastly_service_name
  service_domain                = "${var.sub_domain}.${var.root_domain}"
  backend_origin_server_address = var.fastly_backend_origin_server_address
  backend_origin_server_name    = var.fastly_backend_origin_server_name
  cache_ttl_seconds             = var.fastly_cache_ttl_seconds
}
