# Senior AWS Production Scenarios — Part 1

These are interview practice scenarios, not claims that the described environment exists in this repository. Answers use a repeatable structure: contain, establish evidence, diagnose, remediate, and prevent recurrence.

## 1. A workload administrator attempts to disable CloudTrail

**Situation:** An administrator in a production member account calls `StopLogging` or changes the trail bucket policy.

**Answer:** Treat audit as an organization control, not a workload-account responsibility. Use an organization trail owned by the management/security design, deliver to a dedicated log-archive account, and protect the destination with restrictive bucket policy, KMS key policy, versioning, retention controls and tightly scoped administration. Apply SCP guardrails to deny destructive CloudTrail actions to member-account principals while preserving the platform's documented break-glass path. SCPs do not grant permissions and do not restrict the management account; design that boundary explicitly.

**Response sequence:** Identify the principal and session, preserve CloudTrail management events and organization trail status, check recent IAM/SCP changes, verify S3 delivery and KMS access, then revoke or constrain compromised credentials. Do not delete evidence. Validate from a controlled test account that a member administrator cannot stop the organization trail or alter the archive.

**Useful commands**
```bash
aws sts get-caller-identity
aws cloudtrail describe-trails --include-shadow-trails
aws cloudtrail get-trail-status --name <trail-arn>
aws cloudtrail get-event-selectors --trail-name <trail-arn>
aws s3api get-bucket-policy --bucket <log-archive-bucket>
```

**Trade-offs / follow-up:** Organization trails centralize visibility but create an account-level dependency on the archive account, KMS policy and delivery configuration. Explain how you alert on missing log delivery, test retention, and protect the management account separately.

## 2. GitHub Actions needs production access without AWS access keys

**Situation:** A deployment workflow currently stores long-lived IAM access keys in repository secrets.

**Answer:** Replace keys with GitHub OIDC federation. Configure an IAM role trust policy for the exact GitHub OIDC provider, repository, branch or protected environment subject. Limit the role permissions to the deployment scope, use short session duration, and separate plan from apply. Require protected environments and reviewers for production. The workflow should request only `id-token: write` and the minimum repository permissions it needs.

**Validate:** Inspect the JWT claims and trust-policy condition, confirm a fork or untrusted branch cannot assume the role, and verify CloudTrail records the assumed-role session. A broad `repo:org/*` subject is not acceptable for production.

```bash
aws sts get-caller-identity
aws iam get-role --role-name github-actions-production
aws iam simulate-principal-policy --policy-source-arn <role-arn> --action-names ec2:TerminateInstances
```

**Trade-off:** OIDC removes static secrets but does not make a workflow trustworthy by itself. Protect workflow files, pin third-party actions to immutable SHAs, require reviews and restrict the role's trust conditions.

## 3. Terraform plan proposes replacing a production database

**Answer:** Stop before apply. Identify the exact attribute causing replacement using `terraform plan` and `terraform show -json`; compare provider/schema changes, configuration drift, immutable AWS attributes and state. Confirm backups, snapshots, retention, maintenance window, replication and application recovery objectives. Ask the service owner to approve a migration plan. Use `prevent_destroy` as an additional guard where appropriate, but do not treat it as a substitute for review.

```bash
terraform plan -out=tfplan
terraform show tfplan
terraform show -json tfplan > plan.json
terraform state show <resource-address>
```

**Senior-level point:** A state backup is not a database backup. If replacement is intended, use an explicit migration strategy such as parallel resource creation, data replication, controlled cutover and rollback criteria.

## 4. Two engineers run Terraform apply at the same time

**Answer:** Use a remote backend with locking supported by that backend, and one controlled pipeline as the production writer. Locking serializes state mutations; it does not prevent two different states from managing the same real resource. Check backend configuration, lock holder, pipeline logs and state lineage/serial before recovery. Never manually delete a lock just because it is inconvenient.

```bash
terraform state list
terraform state pull > state-backup.json
terraform plan
```

**Recovery:** Stop competing writers, preserve a state backup, identify the authoritative state and lock owner, then release a stale lock only after verifying no active operation remains. Use state push only as a carefully reviewed recovery action.

## 5. GuardDuty reports suspicious API activity in one account

**Answer:** Validate finding type, resource, account, region, first/last seen and threat context. Treat it as potentially real while investigating. Preserve CloudTrail events, identify principal/session source IP and user agent, inspect credential age and role assumption chain, and correlate with Config and workload logs. Contain by disabling or rotating the affected credential, restricting role trust or isolating the workload when justified. Do not blindly delete resources before collecting evidence.

**Prevention:** Centralize findings, define severity-based routing, test response playbooks, and measure time to acknowledge/contain. GuardDuty detects; it does not automatically prove compromise.

## 6. A public S3 bucket is discovered

**Answer:** Confirm whether public access is intentional and authorized. Check account-level and bucket-level Block Public Access, bucket policy, ACLs, access points and object ownership. Preserve policy history and access evidence, remove unintended exposure, rotate exposed credentials if needed, and notify data owners/security according to incident policy.

```bash
aws s3api get-public-access-block --bucket <bucket>
aws s3api get-bucket-policy-status --bucket <bucket>
aws s3api get-bucket-ownership-controls --bucket <bucket>
aws s3api get-bucket-acl --bucket <bucket>
```

**Trade-off:** Block Public Access is a strong default, but exceptions must be explicit, reviewed and monitored. A green scanner result does not replace data classification.

## 7. Production deployment succeeds but application cannot reach RDS

**Answer:** Trace the packet path rather than changing random rules. Confirm DNS resolution, route tables, subnet association, security-group source/destination, NACL stateless return path, database listener and application credentials. Verify the application uses the intended endpoint and port. Check VPC Flow Logs for ACCEPT/REJECT evidence.

```bash
aws ec2 describe-route-tables --filters Name=vpc-id,Values=<vpc-id>
aws ec2 describe-security-groups --group-ids <sg-id>
aws ec2 describe-network-acls --filters Name=vpc-id,Values=<vpc-id>
```

**Prevention:** Model network dependencies, use private connectivity, keep security-group rules narrow, and add connectivity tests to deployment validation.

## 8. KMS key policy change causes service failures

**Answer:** Identify the key ARN, recent key-policy and grant changes, caller principal, encryption context and service integration. Restore the minimum required key permissions through a reviewed change. Ensure key administration and key usage are separate roles, and preserve a tested recovery path. Do not grant `kms:*` to all principals as a quick fix.

```bash
aws kms get-key-policy --key-id <key-arn> --policy-name default
aws kms list-grants --key-id <key-arn>
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=PutKeyPolicy
```

## 9. Security Hub findings are duplicated across regions/accounts

**Answer:** Confirm delegated administrator, aggregation region, linked regions, product integrations and finding identifiers. Distinguish duplicate ingestion from separate findings with different resources or controls. Normalize routing and suppression rules centrally, retaining auditability and ownership. Never suppress a finding only to make a dashboard look clean.

## 10. A developer accidentally commits Terraform state

**Answer:** Treat state as sensitive because it can contain credentials and secret values. Remove it from repository history using an approved history-rewrite process, rotate any exposed secrets, invalidate tokens, and inspect forks/caches/artifacts. Move state to a protected remote backend with encryption, access controls, versioning and locking. Add ignore rules and secret scanning. Deleting the latest file alone does not remove historical exposure.

## 11. AWS Config shows resources are non-compliant

**Answer:** Confirm recorder status, delivery channel, rule scope, evaluation timestamp and resource coverage. Determine whether the finding is a real control failure, unsupported resource type, missing permission or stale evaluation. Assign an owner and remediation SLA. Use auto-remediation only after testing blast radius and rollback.

## 12. NAT Gateway costs spike unexpectedly

**Answer:** Break down cost by NAT Gateway hours and data processing, region, AZ and workload. Inspect traffic patterns, cross-AZ routing, public endpoints and missing VPC endpoints. Use CloudWatch metrics, VPC Flow Logs and Cost and Usage Report data. Add S3/DynamoDB gateway endpoints where appropriate, interface endpoints where justified, and avoid routing large internal flows through NAT unnecessarily.

## 13. An SCP blocks a legitimate deployment

**Answer:** Identify the affected principal, action, resource, OU/account attachment and explicit deny. SCPs define maximum permissions; an IAM allow cannot override an SCP deny. Reproduce in a non-production OU, narrow the policy condition or create an approved exception OU, and retain audit evidence. Never detach a root-level guardrail ad hoc in production.

## 14. Cross-account role assumption fails

**Answer:** Evaluate both sides: caller identity policy must allow `sts:AssumeRole`, and target role trust policy must trust the caller. Then check SCPs, permission boundaries, session policies, external ID requirements, MFA conditions and organization restrictions. Use CloudTrail in both accounts to establish where the request was denied.

```bash
aws sts get-caller-identity
aws iam get-role --role-name <target-role>
aws iam simulate-principal-policy --policy-source-arn <caller-arn> --action-names sts:AssumeRole
```

## 15. A VPC peering connection is active but traffic fails

**Answer:** Active peering only confirms the control-plane connection. Verify non-overlapping CIDRs, routes in both VPCs, security groups, NACLs, DNS options and return path. Peering is non-transitive; do not design hub routing through chained peerings. For many VPCs, evaluate Transit Gateway and its route tables/attachments.

## 16. An EKS workload cannot retrieve a secret

**Answer:** Identify whether access uses IRSA or EKS Pod Identity, confirm service-account association, trust conditions, role permissions, secret resource policy, KMS decrypt rights and network access to the service endpoint. Check pod events and application SDK region/identity. Avoid node-role-wide secret permissions.

## 17. Terraform reports state drift

**Answer:** Run a refresh-aware plan and inspect the resource-level diff. Determine whether drift is emergency manual change, console edit, provider normalization or external controller ownership. Do not automatically overwrite a security hotfix. Decide whether to import/adopt, update code or revert the manual change, then document ownership and policy.

## 18. A regional AWS service outage affects production

**Answer:** Establish impact against SLOs and dependencies. Check AWS Health, service status and regional metrics; activate the documented failover decision, not an improvised migration. Validate data replication lag, DNS/traffic steering, secrets, KMS keys, quotas and dependencies in the recovery region. Measure RTO/RPO and run regular game days.

## 19. CloudTrail logs stop arriving in the archive bucket

**Answer:** Check trail status, delivery error, S3 bucket policy, KMS key policy, region/organization trail configuration, object ownership and service control restrictions. Alert on delivery gaps, not only trail configuration state. Preserve the outage window and reconstruct evidence from available event sources where possible.

## 20. A critical IAM policy has become overly permissive

**Answer:** Identify the principal, policy source (inline, attached, boundary, resource policy), effective actions and access analyzer findings. Compare required actions to CloudTrail usage and application dependencies. Replace wildcard actions/resources with scoped permissions, stage rollout, monitor AccessDenied and retain rollback. Avoid using last-accessed data as the sole source of truth because it may be delayed or incomplete.

---
## Interview answer framework

For any incident, structure the answer in this order:

1. **Impact and scope:** which account, region, service, data and users?
2. **Containment:** what prevents further damage without destroying evidence?
3. **Evidence:** CloudTrail, Config, service logs, metrics, flow logs and timestamps.
4. **Root cause:** identity, policy, network, configuration, capacity or dependency?
5. **Recovery:** reversible, approved change with validation and rollback.
6. **Prevention:** guardrail, test, alert, ownership and runbook.
7. **Measure:** time to detect, acknowledge, contain and recover.
