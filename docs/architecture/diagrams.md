# Architecture Diagrams

GitHub renders Mermaid diagrams directly in Markdown. The diagrams below are the canonical repository views; they are intentionally not dependent on external image hosting.

## Multi-account governance and security

```mermaid
flowchart TB
  subgraph ORG["AWS Organizations"]
    M["Management account"]
    G["SCP guardrails"]
    I["IAM Identity Center"]
    M --> G
    M --> I
  end
  subgraph DEV["Workload accounts"]
    D["Dev"]
    T["Test"]
    P["Production"]
  end
  subgraph SEC["Security accounts"]
    A["Log Archive"]
    S["Security Tooling"]
  end
  CI["GitHub Actions"] --> O["OIDC federation"] --> R["Scoped deployment role"]
  R --> D
  R --> T
  R --> P
  G -.-> D
  G -.-> T
  G -.-> P
  I -.-> D
  I -.-> T
  I -.-> P
  D --> CT["Organization CloudTrail"]
  T --> CT
  P --> CT
  CT --> A
  D --> GD["GuardDuty / Config"]
  T --> GD
  P --> GD
  GD --> S
```

## Secure deployment flow

```mermaid
sequenceDiagram
  participant Dev as Engineer
  participant PR as GitHub Pull Request
  participant CI as GitHub Actions
  participant AWS as AWS STS / IAM
  participant TF as Terraform
  Dev->>PR: Commit infrastructure change
  PR->>CI: Trigger validation
  CI->>CI: fmt, validate, TFLint, Checkov
  CI-->>PR: Required check result
  Dev->>PR: Review and approve
  CI->>AWS: Exchange GitHub OIDC token
  AWS-->>CI: Short-lived role credentials
  CI->>TF: Generate reviewed plan
  TF-->>Dev: Plan artifact / change summary
  Dev->>CI: Approve protected production apply
  CI->>TF: Apply approved plan
```

## VPC lab topology

```mermaid
flowchart TB
  IGW["Internet Gateway"]
  subgraph VPC["VPC 10.40.0.0/16"]
    subgraph AZ1["Availability Zone A"]
      PUB1["Public subnet 10.40.1.0/24"]
      PRIV1["Private subnet 10.40.11.0/24"]
    end
    subgraph AZ2["Availability Zone B"]
      PUB2["Public subnet 10.40.2.0/24"]
      PRIV2["Private subnet 10.40.12.0/24"]
    end
    NAT["Optional NAT Gateway<br/>first public subnet"]
    PRIV1 --> NAT
    PRIV2 --> NAT
  end
  IGW --> PUB1
  IGW --> PUB2
```

The current lab uses one optional NAT Gateway, disabled by default. For production, evaluate one NAT per AZ or centralized egress through a network account, depending on resilience and cost requirements.

## Diagram scope

- The organization and central-security views are reference architecture.
- The VPC diagram reflects the current Terraform lab defaults.
- These diagrams do not imply that AWS resources have been deployed.
