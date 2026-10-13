# AUTH-002 — Broken object-level authorization

## Scenario

Two authorized lab accounts exist. Account A can retrieve its own synthetic invoice. The same read-only request with Account B's session returns Account A's invoice after changing only the object identifier.

## Expected result

`confirmed` when the role comparison and redacted response prove cross-account access.

## Required guard

Use only synthetic lab records and stop after the minimum proof.
