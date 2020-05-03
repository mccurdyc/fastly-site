# Fastly [mccurdyc.dev](https://www.mccurdyc.dev)

## Getting Started

```bash
$ git clone --recurse-submodules git@github.com:mccurdyc/fastly-site.git
```

### Required Technologies

| Technology                                               	| My Version                                                                                                           	|
|----------------------------------------------------------	|--------------------------------------------------------------------------------------------------------------------- 	|
| [`hugo`](https://gohugo.io/)                             	| `v0.67.0-DEV/extended linux/amd64`                                                                                   	|
| [`terraform`](https://www.terraform.io/downloads.html)   	| `v0.12.21`                                                                                                           	|
| [Google Cloud SDK](https://cloud.google.com/sdk/install) 	| `Google Cloud SDK 284.0.0 alpha 2020.03.06 beta 2020.03.06 bq 2.0.54 core 2020.03.06 gsutil 4.48 kubectl 2020.03.06` 	|

### Optional Technologies

+ [`kolypto/j2cli`](https://github.com/kolypto/j2cli)
```bash
$ pip3 install j2cli
```

```bash
$ gcloud auth application-default login
$ (cd terraform && terraform init)
```

Write the sensitive information to a config JSON file to be used as variables in
future Terraform commands.

```bash
$ cat << EOF > terraform/config.json
{
  "gcp": {
    "email": "<your_gcp_account_email_here>",
    "billing_account_id": "<your_billing_account_id_here>"
    "dns_txt_verify": "<your_dns_txt_record_to_prove_domain_ownership>"
  },
  "fastly": {
    "api_key": "<your_key_here>"
  }
}
EOF
$ make gen-variables
```

```bash
$ make pull-tfstate-files && pushd terraform
$ terraform plan
$ terraform apply
$ popd && make push-tfstate-files
```
