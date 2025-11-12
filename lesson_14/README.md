# Lesson 14: Enterprise-Level Terraform Project Structure

This project demonstrates enterprise-level Terraform code organization with separate environments and reusable modules.

## Project Structure

```
lesson_14/
├── modules/
│   └── pasv_project/          # Reusable Terraform module
│       ├── ec2.tf
│       ├── iam.tf
│       ├── lambda.tf
│       ├── locals.tf
│       ├── outputs.tf
│       ├── providers.tf       # Only provider requirements (no configuration)
│       ├── s3.tf
│       ├── user_data.sh.tftpl
│       ├── variables.tf
│       ├── vpc.tf
│       ├── lambda_src/
│       └── layer/
├── dev/                       # Development environment
│   ├── backend.tf            # S3 backend: dev/pasv_project.tfstate
│   ├── main.tf               # Calls pasv_project module
│   ├── outputs.tf
│   ├── provider.tf           # Provider configuration for dev
│   ├── variables.tf          # Dev-specific variables
│   └── terraform.tfvars.example
└── staging/                   # Staging environment
    ├── backend.tf            # S3 backend: staging/pasv_project.tfstate
    ├── main.tf               # Calls pasv_project module
    ├── outputs.tf
    ├── provider.tf           # Provider configuration for staging
    ├── variables.tf          # Staging-specific variables
    └── terraform.tfvars.example
```

## SSH Access

### Using Auto-Generated Key

If you didn't provide a `key_name`, Terraform automatically generated an SSH key pair:

```bash
# Get the EC2 public DNS
EC2_DNS=$(terraform output -raw ec2_public_dns)

# Connect using the auto-generated key
terraform output -raw private_key_pem > staging-key.pem
ssh -i staging-key.pem -o IdentitiesOnly=yes ec2-user@$ -vv
```

## Module Usage

The `pasv_project` module is located in `modules/pasv_project/` and can be called from any environment:

```hcl
module "pasv_project" {
  source = "../modules/pasv_project"

  region             = var.region
  project_tag        = "pasv-dev"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  allowed_ssh_cidr   = var.allowed_ssh_cidr
  instance_type      = var.instance_type
  key_name           = var.key_name
  bucket_name        = var.bucket_name
}
```

## Best Practices Demonstrated

1. **Module Separation**: Common infrastructure code in reusable module
2. **Environment Isolation**: Separate state files and configurations per environment
3. **Backend Configuration**: Each environment has its own state file path
4. **Variable Customization**: Environment-specific defaults (e.g., instance types, CIDR ranges)
5. **Provider Management**: Provider configured at environment level, not in module
6. **Security**: terraform.tfvars files excluded from git (use .gitignore)
7. **Auto-Generated SSH Keys**: Automatically creates EC2 key pairs when not provided

## Notes

- Each environment maintains its own Terraform state in S3
- State files are encrypted and use DynamoDB for locking
- Modules should not configure providers, only declare requirements