# Senior system-design scenarios

## 1 — 40 AWS accounts, centralized governance
**Requirements:** Dev/Test/Prod isolation, audit and self-service.
**Design:** Organizations OUs for Security, Infrastructure, Workloads and Sandbox; Control Tower landing zone; IAM Identity Center; organization trail; Config; delegated GuardDuty/Security Hub administration; central log archive; account vending with baseline verification.
**Trade-offs:** More accounts improve isolation but increase quotas, inventory and operations. SCP changes have broad blast radius.
**Validation:** Do not hand over an account until audit, Config and detection enrollment are verified.

## 2 — Secure GitHub Actions deployment
**Requirements:** No static keys, branch protection and production approval.
**Design:** GitHub OIDC provider, role trust scoped to exact repository/environment subject and audience, protected environment, least-privilege role and short session.
**Failure modes:** Wildcard trust, fork PR token exposure, compromised action and over-permissioned role.
**Validation:** Test allowed/denied subjects and inspect CloudTrail AssumeRoleWithWebIdentity.

## 3 — Centralized audit and tamper resistance
Use a dedicated log archive account, organization trail, restrictive S3 bucket policy, KMS encryption, separate key administration, lifecycle/retention and delivery monitoring. Test that workload admin cannot delete archived records. Trade-off: cross-account policy complexity and storage cost.

## 4 — Hybrid connectivity for 25 VPCs
Use Transit Gateway with route tables per trust zone, VPN and/or Direct Connect, IPAM, Route 53 Resolver endpoints, flow telemetry and controlled egress. Test failover, route isolation and DNS. Trade-off: centralized routing dependency and processing charges.

## 5 — Regional disaster recovery
Classify workloads and choose backup/restore, pilot light or warm standby per tier. Replicate required data, codify infrastructure and maintain traffic failover. Measure RTO/RPO in timed recovery tests. Faster recovery generally costs more.

## 6 — Security finding across accounts
Aggregate findings through delegated administration; EventBridge routes by severity/account/tag; incident workflow creates a ticket/page; service catalog identifies owner. Start disruptive containment with human approval to avoid accidental outage.

## 7 — Restrict Regions safely
Inventory global services and dependencies. Test region guardrails in non-production OU; monitor AccessDenied. Exemptions should be narrow and documented.

## 8 — Organization-wide key rotation
Inventory key type, owner and consumers. Distinguish KMS key rotation from application secret rotation. Stage migration, validate consumer access and monitor failures. Avoid blind rotation that breaks data access.

## 9 — Terraform state incident
Freeze applies, preserve backend versions/logs, identify state key/workspace/lock, compare known-good state with actual resources, restore only after peer review, then plan. Don't edit state JSON as first response.

## 10 — Cost governance at scale
Tag owner/environment, set budgets, analyze Cost and Usage data, detect idle/oversized resources, review NAT/endpoint/logging charges and create exception workflow. Optimize architecture rather than removing essential security controls.

## Whiteboard sequence
1. Ask account count, users, Regions, RTO/RPO and compliance boundaries.
2. Draw organization/OUs and account boundaries.
3. Add human and machine identity paths.
4. Add network/data flows and trust boundaries.
5. Add audit/detection paths.
6. Add delivery gates and operational ownership.
7. Discuss failure, rollback and cost.
