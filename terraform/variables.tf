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
