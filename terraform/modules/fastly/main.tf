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

  header {
      action        = "set"
      destination   = "http.Strict-Transport-Security"
      ignore_if_set = false
      name          = "Generated by force TLS and enable HSTS"
      priority      = 100
      source        = "\"max-age=300\""
      type          = "response"
  }

  request_setting {
    bypass_busy_wait = false
    force_miss       = false
    force_ssl        = true
    geo_headers      = true
    max_stale_age    = 0
    name             = "Generated by force TLS and enable HSTS"
    timer_support    = false
  }

  cache_setting {
    name = "default"
    ttl = var.cache_ttl_seconds
  }

  force_destroy = true
}
