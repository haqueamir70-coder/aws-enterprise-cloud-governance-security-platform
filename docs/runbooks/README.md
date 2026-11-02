# Operations runbooks

## RB-01 — Suspected credential compromise
1. Declare incident; identify account, principal, time range and owner.
2. Preserve CloudTrail and relevant workload evidence.
3. Disable/rotate exposed long-lived credentials; revoke affected sessions where supported.
4. Review AssumeRole events, trust changes and policy mutations.
5. Contain impacted resources; quarantine only under approved process.
6. Hunt for persistence: new users/keys/roles, event rules, snapshots and network paths.
7. Rebuild from trusted IaC if integrity is unknown.
8. Record timeline, scope, root cause and follow-up actions.

## RB-02 — Unexpected Terraform drift
1. Stop automated applies.
2. Confirm account, region, backend and state key.
3. Run read-only plan and inspect refresh changes.
4. Identify emergency change, console edit, provider change or state mismatch.
5. Do not state rm/import/mv without peer-reviewed recovery plan and backup.
6. Reconcile desired state through code; peer review before apply.
7. Document drift source and preventive action.

## RB-03 — SCP blocks deployment
1. Identify denied API action and effective SCP chain.
2. Confirm caller, account and OU.
3. Determine whether denial is intentional.
4. Use approved break-glass and narrowly scoped exception if required.
5. Test correction in sandbox OU.
6. Record policy, approver, impacted accounts and exception expiry.

## RB-04 — Critical GuardDuty / Security Hub finding
1. Validate account, region, resource and timestamps.
2. Assess severity, exposure, exploitability and business criticality.
3. Correlate CloudTrail, Config history and workload telemetry.
4. Assign owner and response SLA.
5. Contain active threats before suppressing findings.
6. Record evidence, disposition and corrective action.

## RB-05 — Lost deployment access
1. Check identity provider and permission-set assignment.
2. Check OIDC subject/audience or human role trust.
3. Check SCP and permission boundary effects.
4. Use separately controlled emergency access; do not weaken global trust.
5. Restore least-privilege access and test with non-admin identity.
