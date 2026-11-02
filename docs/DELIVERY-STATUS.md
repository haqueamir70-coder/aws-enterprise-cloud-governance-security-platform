# Delivery status and evidence

This repository distinguishes code and design from cloud resources actually deployed.

| Area | Status | Verification |
|---|---|---|
| Architecture and account operating model | Documented | Review architecture guide |
| Single-account Terraform network baseline | Implemented as code | fmt, init -backend=false, validate |
| Example SCP guardrails | Examples only; not attached to an OU | Test in isolated organization OU |
| GitHub Actions OIDC trust | Example template | Replace placeholders and validate in AWS |
| CI workflow | Configured | Inspect GitHub Actions run |
| Organization trail / Config / Security Hub / GuardDuty | Target design and runbook | Requires AWS Organizations permissions |
| Control Tower / account vending | Operating model documented | Requires a governed AWS Organization |
| Production deployment | Not performed / not claimed | Requires authorization and evidence |

## Production-readiness evidence checklist
- [ ] Terraform validation and security scans pass on the intended commit.
- [ ] Peer review approves the plan and blast radius.
- [ ] IAM trust is scoped to exact repository, branch/environment and audience.
- [ ] SCPs are tested in a sandbox OU with rollback and break-glass access.
- [ ] Audit and security findings are verified from a separately controlled account.
- [ ] Log bucket policies, encryption, retention and access boundaries are tested.
- [ ] Incident response and recovery are exercised.
- [ ] Cost estimate and actual billing are reviewed.
- [ ] Evidence is recorded without exposing account IDs, secrets or sensitive logs.
