# Zero-to-Hero Project Guide — AWS enterprise governance

## 1. Business scenario
A company has many AWS accounts and needs centralized guardrails, identity federation, audit and security posture without giving every team organization-wide admin.

## 2. Architecture and end-to-end flow
AWS Organizations/OUs establish account structure; SCPs set permission boundaries; IAM federation grants roles; centralized CloudTrail and security services collect evidence.

## 3. Tool-by-tool inventory
AWS Organizations, OUs, SCP, IAM, IAM Identity Center, GitHub OIDC, CloudTrail, AWS Config, Security Hub, VPC, Terraform, S3 state.

## 4. What you must understand before implementation
Understand the business requirement and success criteria first. Then learn the relevant network/security primitives, identity model, service limits, configuration files, deployment lifecycle, observability signals and recovery strategy. For every tool, be able to explain: what problem it solves, why it was selected, what alternative exists, how it is configured, how it fails and how you verify it.

## 5. Implementation / operations sequence
1. Read the repository README, source files, Terraform modules, manifests and workflow YAML.
2. Map every resource and tool to the architecture diagram.
3. Run local formatting, validation, unit tests and static scans.
4. Review the plan/build artifact before any deployment.
5. Deploy only to an authorized sandbox with least-privilege identity.
6. Verify actual service behavior, network paths, security boundaries and monitoring.
7. Record evidence, cleanup steps, cost and rollback procedure.

## 6. Scenario-based interview questions and answers
**Q: SCP grants permissions?** A: No. SCP sets maximum permissions; IAM policies grant actions within that boundary.

**Q: GitHub static key leaked?** A: Revoke, inspect CloudTrail, review role trust and resource changes, then migrate to scoped OIDC role.

**Q: Why multi-account?** A: Isolation of blast radius, billing, environments and ownership; centralize shared controls.

**Q: Config vs Security Hub?** A: Config records/evaluates resource configuration; Security Hub aggregates security findings/posture.

## 7. Troubleshooting method
Start with the user-visible symptom; establish scope and recent changes; inspect logs/events/metrics; verify identity and permissions; verify DNS/network path; inspect resource limits and service health; isolate one layer at a time; mitigate safely; then document root cause and prevention.

## 8. Security, reliability and cost
Use least privilege, secret management, encrypted transport/storage, explicit network boundaries, patching/scanning, backups, actionable alerts, capacity planning and owner accountability. Estimate cost drivers before scaling or enabling verbose diagnostics.

## 9. Zero-to-Hero study plan
**Foundation:** Linux, Git, networking, YAML/JSON and cloud fundamentals.  
**Project tools:** learn each tool in the inventory and reproduce the repository workflow.  
**Hands-on:** deploy a disposable environment, break one component deliberately, diagnose it and restore service.  
**Interview:** explain the business scenario, diagram, tool choices, data/request flow, security controls, failure modes, cost trade-offs and evidence without reading notes.

## 10. Evidence and scope honesty
This guide is a learning and interview companion. The repository's code, workflow runs and deployment evidence determine what is implemented. Explicitly label each capability as implemented, CI-validated, cloud-deployed or planned. Never claim a tool is used in the live project merely because it appears in a conceptual architecture.
