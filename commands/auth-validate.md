---
name: auth-validate
description: Convert an authentication or authorization observation into a reproducible validation record.
---

# /auth-validate

For the supplied observation, separate facts from assumptions and produce:

- preconditions;
- authorized identities and roles used;
- minimal reproduction steps;
- expected versus observed behavior;
- redacted evidence references;
- impact supported by the evidence;
- false-positive checks;
- a clear validation status: confirmed, not reproducible, or needs more evidence.

Do not escalate testing scope or retrieve unrelated data to prove impact.
