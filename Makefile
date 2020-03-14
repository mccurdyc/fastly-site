TFSTATE_BUCKET=mccurdyc-dot-dev-tfstate

default: help

.PHONY: install-tools
install-tools: ## Installs helpful tools.
	pip install j2cli

.PHONY: gen-variables
gen-variables: ## Fills in the templated sensitive information.
	j2 -f json terraform/terraform.tfvars.j2 terraform/config.json -o terraform/terraform.tfvars

.PHONY: push-tfstate-files
push-tfstate-files: ## Pushes the Terraform state files _to_ a GCP Cloud Storage bucket.
	gsutil cp terraform/*.tfstate* gs://$(TFSTATE_BUCKET)/

.PHONY: pull-tfstate-files
pull-tfstate-files: ## Pulls the Terraform state files _from_ a GCP Cloud Storage bucket.
	gsutil cp gs://$(TFSTATE_BUCKET)/terraform.tfstate terraform/
	gsutil cp gs://$(TFSTATE_BUCKET)/terraform.tfstate.backup terraform/

.PHONY: help
help: ## Prints this help menu.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
