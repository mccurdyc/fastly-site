variable "root_domain" {
  type        = string
  description = "The root or Apex domain (e.g., mccurdyc.dev)"
}

variable "sub_domain" {
  type        = string
  description = "A subdomain (e.g., 'www')."

  default = "www"
}

variable "asset_domain_prefix" {
  type        = string
  description = "The subdomain prefix for the static assets (e.g., 'assets' for assets.mccurdyc.dev)."

  default = "assets"
}

variable "gcp_project_name" {
  type        = string
  description = "The Google Compute Platform project name."

  default = "my-website"
}

variable "gcp_project_id" {
  type        = string
  description = "The Google Compute Platform project id."
}

variable "gcp_billing_account_id" {
  type        = string
  description = "The managing Google Compute Platform billing account ID."
}

variable "gcp_user_email" {
  type        = string
  description = "The managing Google Compute Platform user email address."
}

variable "gcp_website_bucket_name" {
  type        = string
  description = "The name of the Google Cloud Storage bucket. It must be the full domain, including the subdomain (e.g., www.mccurdyc.dev)."
}

variable "gcp_logs_bucket_name" {
  type        = string
  description = "The name of the Google Cloud Storage bucket for logs."
}

variable "fastly_tls_host" {
  type        = string
  description = "The Fastly host for TLS."
}

variable "dns_txt_verify" {
  type        = string
  description = "The TXT DNS record for verifying ownership of the domain."
}

variable "fastly_api_key" {
  type        = string
  description = "The Fastly API key to use for resource creation."
}

variable "fastly_service_name" {
  type        = string
  description = "The name of the Fastly service."

  default = "my-website"
}

variable "fastly_backend_origin_server_address" {
  type        = string
  description = "The backend origin server address to be used in a Fastly service."
}

variable "fastly_backend_origin_server_name" {
  type        = string
  description = "The backend origin server name to be used in a Fastly service."
}

variable "fastly_cache_ttl_seconds" {
  type        = number
  description = "The cache Time-to-Live in seconds."

  default = 300
}
