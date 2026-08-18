.PHONY: init plan apply fmt lint security docs

init:
	terraform init

plan:
	terraform plan

apply:
	terraform apply

fmt:
	terraform fmt -recursive

lint:
	tflint --recursive

security:
	tfsec .

docs:
	terraform-docs markdown table --output-file README.md .
