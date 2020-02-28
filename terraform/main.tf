resource "google_billing_account_iam_member" "binding" {
  billing_account_id = "01A464-869E60-AC80F8"
  role               = "roles/billing.admin"
  member = "user:mccurdyc22@gmail.com"
}

resource "google_project" "mccurdyc_dot_dev" {
  name       = "mccurdyc-dot-dev"
  project_id = "daring-octane-268913"

  billing_account = google_billing_account_iam_member.binding.billing_account_id
}
