---
name: hunt-auth-bypass
description: Evidence-first hunting for authentication, session, recovery, token, and authorization bypasses on explicitly authorized web and API targets.
---

# Hunt Auth Bypass

Use this skill when the user asks to assess login, sessions, password recovery, MFA, tokens, roles, permissions, protected routes, or object access controls.

## Safety gate

Before any live request, establish all three items:

1. The target is owned by the user, an approved lab, or an explicitly authorized program.
2. The exact hostname, application, API, account, and testing window are in scope.
3. The requested action does not require collecting unnecessary secrets or private data.

If any item is missing, remain at the planning level and ask for an in-scope lab or written authorization. Never broaden scope from a discovered hostname, redirect, email address, or third-party service.

## Core model

Keep these questions separate:

- **Authentication:** how does the system establish who the caller is?
- **Session integrity:** how does the system create, rotate, expire, revoke, and transport that identity?
- **Authorization:** after identity is established, what actions and objects may the caller access?

Treat a claim as a hypothesis until it survives a controlled comparison between two explicitly authorized identities or session states.

## Review sequence

### 1. Map the identity surface

Record only what is needed:

- login and logout entry points
- registration and recovery paths
- MFA or step-up checkpoints
- session cookies, bearer tokens, and refresh behavior
- roles, tenants, object identifiers, and privileged actions
- relevant browser, API, proxy, and gateway boundaries

### 2. Build a comparison matrix

Use named, non-production test identities where possible:

| State | Identity | Expected capability | Observed result | Evidence |
|---|---|---|---|---|
| Anonymous | none | public only | pending | request/response reference |
| Basic user | account A | own objects | pending | request/response reference |
| Peer user | account B | own objects | pending | request/response reference |
| Privileged test user | approved role | documented admin actions | pending | request/response reference |

### 3. Choose low-impact hypotheses

Prioritize checks that are reversible and do not expose data:

- a protected route with no session
- the same route under an expired or revoked session
- a documented object identifier owned by the comparison account
- the same action through a different supported HTTP method
- a token or session before and after login, logout, or privilege change
- a recovery or MFA step resumed from an invalid state

Do not brute-force credentials, guess secrets, bypass rate limits, or access unrelated records.

### 4. Validate the boundary

A candidate becomes reportable only when all of these are true:

- the behavior is reproducible with a short sequence;
- the expected control is documented or logically required by the role model;
- the result is materially different for an unauthorized identity or state;
- the evidence avoids unnecessary personal data and secrets;
- the impact is stated without speculation.

### 5. Classify the result

Return one of these statuses:

- **confirmed** — the unauthorized behavior is reproducible and supported by redacted evidence;
- **not reproducible** — the expected control held during the comparison;
- **needs more evidence** — the observation is plausible but lacks a required role comparison, response, or impact proof;
- **out of scope** — the target, account, action, or data is not authorized.

### 6. Write the finding

Use `templates/vulnerability-report.md`. Include the smallest useful request/response pair, account roles, preconditions, exact steps, expected behavior, observed behavior, impact, and a practical remediation direction.

## Output rules

- Label unverified observations as hypotheses.
- Never invent a response, status code, account role, or impact.
- Do not include live credentials, session tokens, personal data, or full customer records.
- Prefer redacted evidence and synthetic identifiers.
- Recommend fixing the server-side authorization decision, not merely hiding a UI control.
