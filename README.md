## Azure Databricks Bootstrap


https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace

## prerequisites

Install azure cli
Install Terraform


$> terraform init   							# Do this once
$> terraform plan --var-file ./configuration/demo.tfvars		# Optional
$> terraform apply --var-file ./configuration/demo.tfvars

#### Terraform folder hierarchy:
```
.
├── README.md
├── configuration
│   └── demo.tfvars
├── main.tf
├── modules
│   ├── adb
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── db
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── firewall
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── keyvault
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── network
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── resource-group
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── variables.tf
```
