module "google-compute-platform" {
  source = "./modules/google-compute-platform"

  project_name        = var.gcp_project_name
  project_id          = var.gcp_project_id
  billing_account_id  = var.gcp_billing_account_id
  user_email          = var.gcp_user_email
  website_bucket_name = var.gcp_website_bucket_name
  root_domain         = var.root_domain
  asset_domain_prefix = var.asset_domain_prefix
}

resource "fastly_service_vcl" "www_mccurdyc_dev" {
  name = "www.mccurdyc.dev"

  domain {
    name = "www.mccurdyc.dev"
  }

  condition {
    name      = "Fastly Image Optimizer Request Condition"
    priority  = 10
    statement = "req.url.ext ~ \"(?i)^(gif|png|jpe?g|webp)$\""
    type      = "REQUEST"
  }

  header {
    action            = "set"
    destination       = "http.x-fastly-imageopto-api"
    ignore_if_set     = false
    name              = "Fastly Image Optimizer"
    priority          = 1
    request_condition = "Fastly Image Optimizer Request Condition"
    source            = "\"fastly\""
    type              = "request"
  }

  backend {
    address           = "assets.mccurdyc.dev"
    name              = "GCP Bucket Load Balancer"
    port              = 443
    use_ssl           = true
    ssl_check_cert    = true
    ssl_cert_hostname = "assets.mccurdyc.dev"
    ssl_sni_hostname  = "assets.mccurdyc.dev"
    shield            = "iad-va-us"
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
    max_stale_age    = 0
    name             = "Generated by force TLS and enable HSTS"
    timer_support    = false
  }

  cache_setting {
    name = "default"
    ttl  = 300
  }

  force_destroy = true
}

resource "fastly_tls_subscription" "www_mccurdyc_dev" {
  domains               = [for domain in fastly_service_vcl.www_mccurdyc_dev.domain : domain.name]
  certificate_authority = "lets-encrypt"
}

resource "fastly_tls_activation" "www_mccurdyc_dev" {
  certificate_id = fastly_tls_subscription.www_mccurdyc_dev.certificate_id
  domain         = "www.mccurdyc.dev"
}

resource "fastly_service_compute" "wasm_mccurdyc_dev" {
  name = "wasm.mccurdyc.dev"

  domain {
    name = "wasm.mccurdyc.dev"
  }

  # Local backend - https://developer.fastly.com/learning/compute/#deploy-the-project-to-a-new-fastly-service
  backend {
    address = "127.0.0.1"
    name    = "localhost"
    port    = 80
  }

  package {
    filename         = "../wasm/pkg/wasm-mccurdyc-dev.tar.gz"
    source_code_hash = filesha512("../wasm/pkg/wasm-mccurdyc-dev.tar.gz")
  }

  force_destroy = true
}

resource "fastly_tls_subscription" "wasm_mccurdyc_dev" {
  domains               = [for domain in fastly_service_compute.wasm_mccurdyc_dev.domain : domain.name]
  certificate_authority = "lets-encrypt"
}

# This will fail to create until the certificate is issued from the CA, so be patient.
resource "fastly_tls_activation" "wasm_mccurdyc_dev" {
  certificate_id = fastly_tls_subscription.wasm_mccurdyc_dev.certificate_id
  domain         = "wasm.mccurdyc.dev"
}

resource "fastly_service_compute" "sandbox_mccurdyc_dev" {
  name = "sandbox.mccurdyc.dev"

  domain {
    name = "sandbox.mccurdyc.dev"
  }

  # Local backend - https://developer.fastly.com/learning/compute/#deploy-the-project-to-a-new-fastly-service
  backend {
    address = "127.0.0.1"
    name    = "localhost"
    port    = 80
  }

  package {
    filename         = "../sandbox/pkg/sandbox-mccurdyc-dev.tar.gz"
    source_code_hash = filesha512("../sandbox/pkg/sandbox-mccurdyc-dev.tar.gz")
  }

  force_destroy = true
}

resource "fastly_tls_subscription" "sandbox_mccurdyc_dev" {
  domains               = [for domain in fastly_service_compute.sandbox_mccurdyc_dev.domain : domain.name]
  certificate_authority = "lets-encrypt"
}

# This will fail to create until the certificate is issued from the CA, so be patient.
resource "fastly_tls_activation" "sandbox_mccurdyc_dev" {
  certificate_id = fastly_tls_subscription.sandbox_mccurdyc_dev.certificate_id
  domain         = "sandbox.mccurdyc.dev"
}
