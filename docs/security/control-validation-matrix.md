# Security Control Validation Matrix

Use this matrix as a review checklist. A control is not complete merely because a service is enabled; validate coverage, evidence, alerting and ownership.

| Control objective | AWS capability / pattern | Evidence to inspect | Failure signal |
|---|---|---|---|
| Organization-wide API audit | CloudTrail organization trail | Trail status, selectors, S3 delivery, KMS | Trail stopped or delivery gap |
| Protect audit archive | Dedicated log archive account, S3 policy, KMS, retention | Bucket policy, key policy, versioning, retention | Workload principal can alter/delete logs |
| Detect suspicious behavior | GuardDuty | Detector status, delegated admin, findings | Region/account not covered |
| Aggregate security posture | Security Hub | Standards, linked regions/accounts, findings | Member account not enrolled |
| Configuration compliance | AWS Config | Recorder, delivery channel, rules, evaluation | Recorder stopped or stale evaluation |
| Least-privilege workforce | IAM Identity Center | Permission sets, assignments, MFA/federation | Shared admin credentials |
| Secure CI identity | GitHub OIDC | Provider, trust conditions, role permissions | Static keys or broad subject |
| Network visibility | VPC Flow Logs | Coverage, destination, retention, queries | Unlogged VPC/subnet |
| Encryption | KMS | Key policy, rotation settings, grants | Broad decrypt or orphaned key |
| Public exposure prevention | S3 Block Public Access, SG review | Account/bucket settings, public status | Unexpected public resource |
| Policy guardrails | SCPs | OU attachments, policy versions, exceptions | Unreviewed deny or unowned exception |
| IaC quality | Terraform fmt/validate, TFLint, Checkov | Workflow run, PR status, scan output | Soft-fail or bypassed required check |

## Minimum validation cadence

- **On every pull request:** formatting, validation, lint, IaC security scan and policy review.
- **On every deployment:** identity confirmation, reviewed plan, approval and post-deploy smoke test.
- **Daily:** audit delivery, critical findings and control-plane changes.
- **Monthly:** access review, exception expiry, security coverage and cost anomalies.
- **Quarterly:** break-glass exercise, restore test, incident tabletop and SCP regression tests.

## Ownership model

Every control needs an accountable owner, an operational owner, an evidence location, an exception process and a measurable response objective. A dashboard without assigned ownership is not a control.
