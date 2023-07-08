SHELL := /usr/bin/env bash -o pipefail

default: help

.PHONY: fmt
fmt: ## Runs terraform fmt on all Terraform files.
	@echo "==> Formatting Terraform files"
	@find . -type f -name '*.tf' -not -path "./.terraform/*" -exec terraform fmt {} \;

.PHONY: init
init: ## Runs terraform init.
	@GOOGLE_CREDENTIALS=$(pwd)/account.json terraform init

.PHONY: fetch-secrets
fetch-secrets: ## Downloads Terraform variables from my secret store.
	@op document get fastly-site-terraform.tfvars > terraform.tfvars
	@op document get fastly-site-sa-creds.json > account.json

help: ## Prints this help menu.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
