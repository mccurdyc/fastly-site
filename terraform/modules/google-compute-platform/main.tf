terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

resource "google_project" "default" {
  name            = var.project_name
  project_id      = "${var.project_name}-website"
  billing_account = google_billing_account_iam_member.binding.billing_account_id
}

resource "google_billing_account_iam_member" "binding" {
  billing_account_id = var.billing_account_id
  role               = "roles/billing.admin"
  member             = format("user:%s", var.user_email)
}

resource "google_compute_global_forwarding_rule" "https" {
  provider = google-beta

  project = google_project.default.project_id
  name    = "${google_project.default.name}-https-rule"

  ip_address = google_compute_global_address.default.address
  target     = google_compute_target_https_proxy.default.self_link
  port_range = "443"

  depends_on = [
    google_compute_global_address.default,
    google_compute_target_https_proxy.default,
  ]
}

resource "google_compute_global_address" "default" {
  project      = google_project.default.project_id
  name         = "${google_project.default.name}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_target_https_proxy" "default" {
  project = google_project.default.project_id
  name    = "${google_project.default.name}-https-lb"

  url_map          = google_compute_url_map.default.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.default.self_link]

  depends_on = [
    google_compute_url_map.default,
    google_compute_managed_ssl_certificate.default,
  ]
}

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta

  name = "website-cert"

  managed {
    domains = ["${var.asset_domain_prefix}.${var.root_domain}."]
  }
}

resource "google_compute_url_map" "default" {
  name            = "url-map"
  default_service = google_compute_backend_bucket.default.self_link

  host_rule {
    hosts        = ["${var.asset_domain_prefix}.dev.${var.root_domain}"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.default.self_link
  }

  depends_on = [
    google_compute_backend_bucket.default,
  ]
}

resource "google_compute_backend_bucket" "default" {
  name        = "website-backend-bucket"
  project     = google_storage_bucket.default.project
  bucket_name = google_storage_bucket.default.name
}

resource "google_storage_bucket" "default" {
  name          = var.website_bucket_name
  project       = google_project.default.project_id
  storage_class = "REGIONAL"
  location      = "US"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  force_destroy = true

  depends_on = [
    google_project.default,
    google_storage_bucket.default,
  ]
}

resource "google_storage_default_object_access_control" "public_bucket_access" {
  bucket = google_storage_bucket.default.name
  role   = "READER"
  entity = "allUsers"

  depends_on = [
    google_storage_bucket.default,
  ]
}

resource "google_dns_managed_zone" "dev" {
  name     = "dev-zone"
  dns_name = "dev.${var.root_domain}."
}

resource "google_dns_record_set" "a" {
  name         = "backend.${google_dns_managed_zone.dev.dns_name}"
  managed_zone = google_dns_managed_zone.dev.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_forwarding_rule.https.ip_address]

  depends_on = [
    google_dns_managed_zone.dev,
    google_compute_global_forwarding_rule.https,
  ]
}

resource "google_dns_record_set" "cname" {
  name         = "${var.asset_domain_prefix}.${google_dns_managed_zone.dev.dns_name}"
  managed_zone = google_dns_managed_zone.dev.name
  type         = "CNAME"
  ttl          = 300

  rrdatas = ["dev.${var.root_domain}."]

  depends_on = [
    google_dns_managed_zone.dev,
  ]
}
