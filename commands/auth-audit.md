---
name: auth-audit
description: Build a bounded authentication and authorization review plan for an explicitly authorized target.
---

# /auth-audit

Create an evidence-first review plan.

Ask for or extract:

- authorized target and exact scope
- application or API entry point
- available test identities and roles
- known login, recovery, MFA, token, and privileged flows
- constraints such as rate limits, data handling, and testing window

Return:

1. an authorization and scope confirmation;
2. an identity-surface map;
3. a role/session comparison matrix;
4. prioritized, low-impact hypotheses;
5. stop conditions and evidence requirements.

Do not perform live testing when scope or authorization is unclear.
