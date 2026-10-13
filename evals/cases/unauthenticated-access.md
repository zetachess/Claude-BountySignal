# AUTH-001 — Unauthenticated protected route

## Scenario

An explicitly authorized lab exposes `/api/profile` without requiring a session. The route returns the synthetic account `lab-user-001`.

## Expected result

`confirmed` when the response is reproducible and redacted evidence shows protected data returned to an anonymous request.

## Required guard

Do not test a real account or retrieve additional records.
