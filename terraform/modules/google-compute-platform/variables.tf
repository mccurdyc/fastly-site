variable "project_name" {
  type        = string
  description = "The Google Compute Platform project name."
}

variable "project_id" {
  type        = string
  description = "The Google Compute Platform project ID."
}

variable "fastly_tls_host" {
  type        = string
  description = "The Fastly host for TLS."
}

variable "dns_txt_verify" {
  type        = string
  description = "The TXT DNS record for verifying ownership of the domain."
}

variable "billing_account_id" {
  type        = string
  description = "The managing Google Compute Platform billing account ID."
}

variable "user_email" {
  type        = string
  description = "The managing Google Compute Platform user email address."
}

variable "website_bucket_name" {
  type        = string
  description = "The name of the Google Cloud Storage bucket. It must be the full domain, including the subdomain (e.g., www.mccurdyc.dev)."
}

variable "logs_bucket_name" {
  type        = string
  description = "The name of the Google Cloud Storage bucket for logs."
}

variable "root_domain" {
  type        = string
  description = "The root or Apex domain (e.g., mccurdyc.dev)"
}

variable "asset_domain_prefix" {
  type        = string
  description = "The subdomain prefix for the static assets (e.g., 'assets' for assets.mccurdyc.dev)."
}
