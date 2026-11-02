# Security control catalogue

## Preventive
- Organization SCPs deny selected high-risk actions; region restrictions follow service-dependency analysis.
- IAM roles use least privilege, explicit trust and short sessions.
- GitHub Actions deploys through OIDC; no long-lived AWS keys.
- Private subnets have no direct internet route unless approved.
- Security groups use narrow CIDRs, protocols and ports.
- KMS key administration and key usage are separated.

## Detective
- CloudTrail captures API activity and sends records to separately controlled storage.
- AWS Config tracks supported resource state and evaluates rules.
- GuardDuty detects suspicious behavior from supported telemetry.
- Security Hub aggregates findings and posture.
- CI scans Terraform for misconfiguration.

## Corrective
- Constrain compromised sessions, preserve evidence and rotate impacted credentials.
- Quarantine affected workloads/accounts using the approved incident process.
- Revert risky policy changes through reviewed commits.
- Rebuild from trusted IaC when integrity cannot be established.

## Ownership
| Control | Owner | Evidence |
|---|---|---|
| Permission-set review | Identity / platform | Quarterly access review |
| SCP rollout | Cloud governance | Change PR, test results, OU attachment |
| CloudTrail integrity | Security operations | Trail status and delivery validation |
| Config coverage | Cloud security | Recorder status and resource coverage |
| Findings triage | SOC / service owner | Ticket, severity, disposition |
| CI role trust | DevSecOps | Trust policy and workflow run |

## Guardrails
Never deploy sample SCPs directly to organization root. Deny policies may block service-linked roles, incident response or recovery. Test in an isolated OU, inspect effective policies and retain emergency access.
