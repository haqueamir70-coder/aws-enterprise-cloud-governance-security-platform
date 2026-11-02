# Deployment guide

## Phase 0 — Authorization and cost
- Use a dedicated non-production AWS account and obtain explicit owner approval.
- Choose region and check service availability.
- NAT gateways, interface endpoints, Config evaluations, GuardDuty, Security Hub and log ingestion can incur charges.
- Set a budget alert and cleanup owner first.

## Phase 1 — Local preflight
```bash
aws --version
terraform version
aws configure list --profile platform-lab
AWS_PROFILE=platform-lab aws sts get-caller-identity
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
```
Confirm the AWS account and principal are the intended sandbox identity.

## Phase 2 — Configure lab
```bash
cp terraform/environments/lab/terraform.tfvars.example terraform/environments/lab/terraform.tfvars
terraform -chdir=terraform plan -var-file=environments/lab/terraform.tfvars -out=tfplan
terraform -chdir=terraform show tfplan
```
Review all creates, updates, replacements and deletes. Check CIDR overlap. NAT is disabled by default; enabling it is billable.

## Phase 3 — Apply with approval
```bash
terraform -chdir=terraform apply tfplan
```
Record commit, Terraform version, region, resource types and approval. Never publish state, plans or identifiers.

## Phase 4 — Validate
- Inspect VPC, subnets and route table associations in the expected account/region.
- Confirm private subnets have no unintended internet gateway route.
- Confirm ingress is limited to intended CIDRs.
- Record actual cost and remove optional resources no longer required.

## Phase 5 — Destroy sandbox
```bash
terraform -chdir=terraform plan -destroy -var-file=environments/lab/terraform.tfvars
# Review all impacts, then:
terraform -chdir=terraform destroy -var-file=environments/lab/terraform.tfvars
```
Do not destroy shared production or centralized logging resources with this lab procedure.

## Multi-account rollout (separate change)
1. Establish Control Tower landing zone and accounts.
2. Configure delegated administrators and organization trails.
3. Configure log archive, encryption, bucket policy and retention.
4. Test SCPs in sandbox OU.
5. Roll out guardrails progressively.
6. Validate detections and response routing.
7. Record approvals, evidence and rollback steps.
