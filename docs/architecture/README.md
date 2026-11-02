# Architecture and design guide

## Design goals
1. Separate workload administration from security and audit ownership.
2. Make identity federated and temporary.
3. Establish repeatable network boundaries through Terraform.
4. Centralize audit and security findings outside workload accounts.
5. Combine preventive, detective and corrective controls.
6. Keep the lab affordable and safe.

## Target account model

| OU | Example accounts | Purpose |
|---|---|---|
| Root | Management | Organization administration and Control Tower orchestration; no workloads |
| Security | Log Archive, Audit / Security Tooling | Centralized audit storage and delegated security administration |
| Infrastructure | Network, Shared Services | DNS, connectivity and approved platform services |
| Workloads | Dev, Test, Production | Application workloads isolated by environment |
| Sandbox | Lab accounts | Restricted experimentation and budgets |
| Quarantine | Suspended / compromised | Restrict access and egress during investigation |

Names are logical examples, not actual account identifiers. Define account ownership, billing, break-glass and delegated administration formally.

## Request and telemetry flow
1. Engineer authenticates through corporate identity provider and IAM Identity Center.
2. Engineer assumes an approved permission set in the target account.
3. Infrastructure changes are proposed in Git and reviewed in pull requests.
4. GitHub Actions exchanges OIDC token for short-lived AWS role credentials.
5. Terraform deploys approved resources in the workload account.
6. CloudTrail and AWS Config record API activity and supported configuration changes.
7. GuardDuty analyzes supported telemetry; Security Hub aggregates findings.
8. Findings and audit events are routed to centrally controlled security/logging accounts.
9. Operators follow runbooks and record remediation evidence.

## Trust boundaries
- Organization: management account and organization-wide service administration.
- Account: IAM, VPC, KMS and resource policies are account-scoped.
- Network: public ingress is explicit; private workloads have no public IP by default.
- CI: OIDC subject and audience must be scoped to repository and protected environment.
- Evidence: plans, state, logs and findings may contain sensitive metadata.

## Service responsibilities

| Service | Responsibility | Design note |
|---|---|---|
| AWS Organizations | Account hierarchy and policy attachment | SCPs are guardrails, not grants |
| Control Tower | Landing zone and account provisioning | Organization-level change |
| IAM Identity Center | Workforce federation and permission sets | Separate admin/read-only roles |
| IAM | Workload roles and resource permissions | Conditions and least privilege |
| VPC | Network isolation | Explicit route tables and SGs |
| Transit Gateway | Hub connectivity | Route segmentation and cost review |
| CloudTrail | API activity history | Organization trail target |
| AWS Config | Resource configuration history/rules | Scope affects cost and coverage |
| GuardDuty | Threat detection | Findings need response ownership |
| Security Hub | Findings and posture aggregation | Tailor standards and controls |
| KMS | Cryptographic key management | Separate key admins and data users |

## Failure and blast-radius thinking
- Workload admins should not disable organization-wide audit.
- A bad SCP can block operators; test in an OU and preserve break-glass.
- Regional recovery requires tested plans, not just a diagram.
- Central log destination delivery must be monitored.
- CI token access must be constrained by OIDC subject, audience, duration and role permissions.

## Diagram legend
The SVGs use AWS service names and recognizable AWS color conventions, but are original vector illustrations, not downloaded official AWS icon assets. The animated flow uses dashed paths and respects reduced-motion preferences.
