resource "google_billing_account_iam_binding" "binding" {
  billing_account_id = "01A464-869E60-AC80F8"
  role               = "roles/billing.viewer"

  members = [
    "user:mccurdyc22@gmail.com",
  ]
}

data "google_billing_account" "mccurdyc_dot_dev_billing_acct" {
  billing_account = google_billing_account_iam_binding.binding.id
  open            = true
}

resource "google_project" "mccurdyc_dot_dev" {
  name       = "mccurdyc-dot-dev"
  project_id = "daring-octane-268913"

  billing_account = data.google_billing_account.mccurdyc_dot_dev_billing_acct.id
}
