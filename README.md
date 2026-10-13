# Claude-BountySignal

Claude-BountySignal is an independent Claude Code plugin for authorized authentication and authorization research, evidence validation, and bug bounty reporting.

Its primary skill is `hunt-auth-bypass`. The project is built around a simple rule: a security observation is not a finding until it is scoped, reproducible, and supported by minimal evidence.

> Claude-BountySignal is an independent community project. It is not affiliated with, endorsed by, or sponsored by Anthropic.

## What it covers

- Login, logout, registration, and account recovery flows
- Session and cookie lifecycle checks
- MFA flow consistency checks
- JWT and token-handling review
- Role and object authorization checks, including IDOR/BOLA hypotheses
- Protected-route and HTTP-method inconsistencies
- Evidence collection and report drafting

## Install

Install `Claude-BountySignal` through the normal Claude Code plugin workflow from this repository. For local development, keep the repository available and load the plugin from its checkout.

The primary skill is available as `hunt-auth-bypass`.

## Commands

- `/auth-audit` — create a bounded test plan from the target's identity model
- `/auth-validate` — turn an observation into a reproducible validation record
- `/auth-report` — draft a concise, remediation-ready vulnerability report

## Operating boundary

Use Claude-BountySignal only against systems you own, approved labs, or assets covered by explicit written authorization. It is not intended to obtain credentials, access unrelated accounts, extract personal data, evade rate limits, or expand an engagement's scope.

## Design principles

1. Evidence before severity.
2. Small, reversible checks before broader testing.
3. Clear separation between authentication, session integrity, and authorization.
4. Reports that a program triager or engineering team can reproduce.
5. Synthetic examples and redacted evidence by default.

## GitHub topics

```text
ai-security, anthropic, application-security, bug-bounty, bugbounty,
bugcrowd, claude, claude-code, claude-skills, ethical-hacking,
hackerone, offensive-security, pentesting, red-team, security-tools,
web-security
```

## Project status

Version `0.1.0` is the initial focused release. Docker labs, Burp integration, and a standalone CLI are intentionally outside this release.

## License

The original source code and documentation in this repository are released under the MIT License. See [LICENSE](LICENSE).
