install-deps:
	pip install j2cli

gen-variables:
	j2 -f json terraform/terraform.tfvars.j2 terraform/config.json -o terraform/terraform.tfvars
