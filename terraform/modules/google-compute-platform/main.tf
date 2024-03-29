resource "google_project" "default" {
  name       = var.project_name
  project_id = var.project_id

  billing_account = var.billing_account_id
}

resource "google_service_account" "manage" {
  account_id   = "mccurdyc-owner"
  display_name = "mccurdyc-owner"
}

resource "google_dns_managed_zone" "default" {
  name        = "www-mccurdyc-dev-zone"
  dns_name    = "${var.root_domain}."
  description = "Managed by Terraform"
  project     = var.project_id
}

resource "google_dns_record_set" "assets" {
  name = "assets.${google_dns_managed_zone.default.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.default.name

  depends_on = [
    google_project.default,
    google_compute_global_address.default,
  ]

  rrdatas = [google_compute_global_address.default.address]
}

resource "google_dns_record_set" "bsky_txt" {
  name = "_atproto.${google_dns_managed_zone.default.dns_name}"
  type = "TXT"
  managed_zone = google_dns_managed_zone.default.name

  rrdatas = ["did=did:plc:7vzwa7bq46pxqngpczavpnwy"]
}

resource "google_dns_record_set" "fastly_cname" {
  name = "www.${google_dns_managed_zone.default.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.default.name

  depends_on = [
    google_project.default,
    google_compute_global_address.default,
  ]

  rrdatas = ["d.sni.global.fastly.net."]
}

resource "google_dns_record_set" "fastly_wasm_cname" {
  name = "wasm.${google_dns_managed_zone.default.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.default.name

  # https://developer.fastly.com/learning/concepts/routing-traffic-to-fastly/
  rrdatas = ["d.sni.global.fastly.net."]
}

resource "google_dns_record_set" "fastly_sandbox_cname" {
  name = "sandbox.${google_dns_managed_zone.default.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.default.name

  # https://developer.fastly.com/learning/concepts/routing-traffic-to-fastly/
  rrdatas = ["d.sni.global.fastly.net."]
}

resource "google_compute_global_forwarding_rule" "https" {
  provider = google-beta

  project = google_project.default.project_id
  name    = "mccurdyc-dot-dev-lb-frontend"

  ip_address = google_compute_global_address.default.address
  target     = google_compute_target_https_proxy.default.self_link
  port_range = "443-443"

  depends_on = [
    google_project.default,
    google_compute_global_address.default,
    google_compute_target_https_proxy.default,
  ]
}

resource "google_compute_global_address" "default" {
  project      = google_project.default.project_id
  name         = "${google_project.default.name}-address"
  address_type = "EXTERNAL"

  depends_on = [
    google_project.default,
  ]
}

resource "google_compute_target_https_proxy" "default" {
  name    = "mccurdyc-dot-dev-lb-target-proxy"
  project = google_project.default.project_id

  url_map          = google_compute_url_map.default.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.default.self_link]

  depends_on = [
    google_project.default,
    google_compute_url_map.default,
    google_compute_managed_ssl_certificate.default,
  ]
}

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta

  name    = "assets-mccurdyc-dot-dev-cert"
  project = google_project.default.project_id

  managed {
    domains = ["${var.asset_domain_prefix}.${var.root_domain}."]
  }
}

resource "google_compute_url_map" "default" {
  name            = "mccurdyc-dot-dev-lb"
  project         = google_project.default.project_id
  default_service = google_compute_backend_bucket.default.self_link

  depends_on = [
    google_compute_backend_bucket.default,
  ]
}

resource "google_compute_backend_bucket" "default" {
  name        = "mccurdyc-dot-dev-backend"
  project     = google_storage_bucket.default.project
  bucket_name = google_storage_bucket.default.name
}

resource "google_storage_bucket" "default" {
  name          = var.website_bucket_name
  project       = google_project.default.project_id
  storage_class = "REGIONAL"
  location      = "US-EAST1"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  force_destroy = true

  depends_on = [
    google_project.default,
  ]
}

resource "google_storage_default_object_access_control" "public_bucket_access_default" {
  bucket = google_storage_bucket.default.name
  role   = "READER"
  entity = "allUsers"

  depends_on = [
    google_storage_bucket.default,
  ]
}

resource "google_storage_bucket" "images" {
  name          = "images.mccurdyc.dev"
  project       = google_project.default.project_id
  storage_class = "REGIONAL"
  location      = "US-EAST1"

  force_destroy = true
}

resource "google_storage_default_object_access_control" "public_bucket_access_images" {
  bucket = google_storage_bucket.images.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket" "random" {
  name          = "random.mccurdyc.dev"
  project       = google_project.default.project_id
  storage_class = "REGIONAL"
  location      = "US-EAST1"

  force_destroy = true
}

resource "google_storage_default_object_access_control" "public_bucket_access_random" {
  bucket = google_storage_bucket.random.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_project_service" "apis" {
  for_each = toset([
    "containerregistry.googleapis.com",
  ])

  project = var.project_id
  service = each.value

  disable_dependent_services = true
}
