# Enterprise AWS Account Model

## Reference organization layout

This is a target-state design for discussion and controlled implementation. It is not automatically deployed by the current Terraform root.

```text
AWS Organization
├── Security OU
│   ├── Log Archive account
│   └── Security Tooling account
├── Infrastructure OU
│   ├── Network account
│   └── Shared Services account
├── Workloads OU
│   ├── Development accounts
│   ├── Test accounts
│   └── Production accounts
├── Sandbox OU
└── Suspended OU
```

## Account responsibilities

| Account | Responsibility | Key boundary |
|---|---|---|
| Management | Organization administration, billing, policy orchestration | No routine workloads; tightly restricted access |
| Log Archive | Central immutable-oriented audit storage | Workload administrators cannot change retention or delete evidence |
| Security Tooling | Delegated security administration, findings aggregation | Security operators separate from workload operators |
| Network | Shared connectivity, DNS and inspection patterns | Central changes require network change control |
| Shared Services | Approved shared platform services | Explicit service ownership and consumption model |
| Workload | Application teams own their runtime | Guardrails inherited from OU and organization |

## Identity and access

- Workforce access should be federated through IAM Identity Center or an enterprise identity provider.
- Map job functions to permission sets; avoid shared human IAM users.
- Separate organization administration, security investigation, network administration and workload deployment.
- Use short-lived role sessions and require MFA for privileged access.
- Use GitHub OIDC for CI/CD, constrained to exact repository and protected branch/environment claims.
- Maintain a documented break-glass role, alert every use, test it, and protect credentials separately.

## Prevent / detect / respond

**Prevent:** SCPs, permission boundaries, least-privilege IAM, approved regions, encryption defaults and private network design.

**Detect:** Organization CloudTrail, AWS Config, GuardDuty, Security Hub, IAM Access Analyzer and centralized log monitoring.

**Respond:** Finding ownership, incident severity, containment authority, evidence preservation, recovery criteria and post-incident actions.

## SCP rollout method

1. Inventory current actions and exceptions.
2. Start with audit-only or simulation where available.
3. Attach to a non-production OU.
4. Test account vending, deployment, logging, support and break-glass paths.
5. Review CloudTrail AccessDenied events and service dependencies.
6. Roll out in waves with an owner and rollback procedure.
7. Monitor policy changes and exception expiry.

SCPs do not grant permissions, do not affect principals in the management account, and do not replace IAM policies. Some service-linked roles and AWS service workflows require special consideration. Validate every policy against the actual account model before attachment.

## Central audit design

- Organization trail captures management events across member accounts and enabled regions.
- Log archive bucket is in a dedicated account with restrictive resource policy and encryption.
- KMS key policy separates key administrators from log writers/readers.
- Enable versioning and an explicit retention/immutability strategy appropriate to legal requirements.
- Alert on trail configuration changes, delivery errors, unexpected gaps and archive policy changes.
- Test restore and evidence retrieval; storage without tested retrieval is not an operational control.

## Network model

Use a dedicated network account for shared connectivity where central inspection is required. Choose Transit Gateway for scalable hub-and-spoke routing; use VPC peering only for limited, non-transitive relationships. Define CIDR allocation, DNS, egress inspection, ingress, private endpoints, flow logging and route ownership. Do not assume a centralized network automatically means all traffic is inspected—prove the route path.

## Deployment boundaries in this repository

- The current Terraform root is a **single-account VPC lab foundation**.
- The organization model, delegated administration, central audit architecture and SCP examples are **reference design / examples**.
- Do not attach example SCPs to production OUs without policy review and a staged test.
- Organization bootstrap requires management-account authority and may have account-specific prerequisites.
