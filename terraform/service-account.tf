resource "google_service_account" "create_access_service_account" {
  account_id   = "create-access"
  display_name = "Create Access Service Account"
}

resource "google_service_account_key" "create_access_key" {
  service_account_id = google_service_account.create_access_service_account.name
}

