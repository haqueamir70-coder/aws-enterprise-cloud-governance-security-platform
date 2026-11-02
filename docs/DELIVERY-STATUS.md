# Delivery status and evidence

This repository distinguishes code and design from cloud resources actually deployed.

| Area | Status | Verification |
|---|---|---|
| Enterprise account model | Documented reference architecture | Review `docs/architecture/enterprise-account-model.md` |
| Single-account Terraform network baseline | Implemented as code | GitHub Actions runs fmt, init and validate |
| Optional VPC Flow Logs | Implemented as code; disabled by default | Review `terraform/modules/network/flow-logs.tf` |
| NAT Gateway | Optional Terraform resource; disabled by default | Review network module and cost before enabling |
| Example SCP guardrails | Examples only; not attached to an OU | Test in isolated organization OU |
| GitHub Actions OIDC trust | Example template | Replace placeholders and validate in AWS |
| CI workflow | Configured; latest run must be checked for final conclusion | Inspect Actions run linked from repository |
| Organization trail / Config / Security Hub / GuardDuty | Target design and runbook | Requires AWS Organizations permissions |
| Control Tower / account vending | Operating model documented | Requires a governed AWS Organization |
| Production deployment | Not performed / not claimed | Requires authorization and evidence |

## CI evidence

The latest workflow has been triggered by the most recent Terraform change. Do not describe the pipeline as green until its run conclusion is successful. Earlier runs passed Terraform format, init and validate but failed at TFLint; the TFLint config path was made explicit and Checkov was changed to a blocking gate. Verify the current run before presenting CI as passing.

## Production-readiness evidence checklist
- [ ] Terraform formatting, validation, lint and security scans pass on the intended commit.
- [ ] Peer review approves the plan and blast radius.
- [ ] IAM trust is scoped to exact repository, branch/environment and audience.
- [ ] SCPs are tested in a sandbox OU with rollback and break-glass access.
- [ ] Audit and security findings are verified from a separately controlled account.
- [ ] Log bucket policies, encryption, retention and access boundaries are tested.
- [ ] Incident response and recovery are exercised.
- [ ] Cost estimate and actual billing are reviewed.
- [ ] Evidence is recorded without exposing account IDs, secrets or sensitive logs.
