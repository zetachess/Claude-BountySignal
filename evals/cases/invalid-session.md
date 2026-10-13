# AUTH-004 — Invalid session reuse

## Scenario

A lab session is explicitly revoked. A previously captured synthetic token is then presented to a protected endpoint.

## Expected result

`confirmed` only if the revoked token still authorizes a protected action and the result is reproducible.
