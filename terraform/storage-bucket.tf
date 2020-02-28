resource "google_storage_bucket" "mccurdyc-dot-dev-store" {
  name          = "mccurdyc-dot-dev-store"
  project       = "daring-octane-268913"
  force_destroy = true
  storage_class = "REGIONAL"
  location      = "US-EAST1"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_default_object_access_control" "public_bucket_access" {
  bucket = google_storage_bucket.mccurdyc-dot-dev-store.name
  role   = "READER"
  entity = "allUsers"
}

