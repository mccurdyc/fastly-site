variable "service_name" {
  type        = string
  description = "The name of the Fastly service."
}

variable "service_domain" {
  type        = string
  description = "A domain added to a Fastly service. It must be the full domain, including the subdomain (e.g., www.mccurdyc.dev)."
}

variable "backend_origin_server_address" {
  type        = string
  description = "The backend origin server address to be used in a Fastly service."
}

variable "backend_origin_server_name" {
  type        = string
  description = "The backend origin server name to be used in a Fastly service."
}

variable "cache_ttl_seconds" {
  type        = number
  description = "The cache Time-to-Live in seconds."
}
