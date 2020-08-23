SHELL := /bin/bash -o pipefail

default: help

.PHONY: fmt
fmt: ## Runs terraform fmt on all Terraform files.
	@echo "==> Formatting Terraform files"
	@find . -type f -name '*.tf' -not -path "./.terraform/*" -exec terraform fmt {} \;

help: ## Prints this help menu.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
