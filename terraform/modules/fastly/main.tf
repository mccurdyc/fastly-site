terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

resource "fastly_service_v1" "website-service" {
  name = var.service_name

  domain {
    name = var.service_domain
  }

  backend {
    address           = var.backend_origin_server_address
    name              = var.backend_origin_server_name
    port              = 443
    use_ssl           = true
    ssl_check_cert    = true
    ssl_cert_hostname = var.backend_origin_server_address
    ssl_sni_hostname  = var.backend_origin_server_address
  }

  cache_setting {
    name = "default"
    ttl = var.cache_ttl_seconds
  }

  // TODO: add bigquerylogging

  force_destroy = true
}
