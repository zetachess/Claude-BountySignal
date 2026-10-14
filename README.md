<a id="readme-top"></a>

<div align="center">
  <img src="assets/claude-bountysignal-landing.png" alt="Claude-BountySignal landing page preview" width="100%">
  <h1>Claude-BountySignal</h1>
  <p><strong>Turn authentication and authorization observations into evidence-backed reports.</strong></p>
  <p>A Claude Code plugin for authorized bug bounty research: scope the review, validate the behavior, and document what the evidence proves.</p>
  <p>
    <a href=".claude-plugin/plugin.json"><img src="https://img.shields.io/badge/version-0.1.0-ef233c.svg" alt="Version 0.1.0"></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-22c55e.svg" alt="MIT License"></a>
    <a href="SECURITY.md"><img src="https://img.shields.io/badge/use-authorized%20testing-f59e0b.svg" alt="Authorized testing only"></a>
  </p>
  <p><a href="#quick-start">Quick start</a> · <a href="#commands-and-workflow">Commands</a> · <a href="templates/vulnerability-report.md">Report template</a> · <a href="https://github.com/zetachess/Claude-BountySignal/issues">Issues and requests</a></p>
</div>

## Overview

Claude-BountySignal helps researchers distinguish an authentication failure, a session integrity issue, and an authorization failure. It provides review instructions, three commands, a reporting template, and synthetic evaluation cases for Claude Code.

```text
Confirm scope → Map identities → Form a hypothesis → Validate → Preserve evidence → Report
```

The current release is an instruction-based plugin. It does not bundle a scanner, browser automation, a Burp integration, or a standalone testing CLI. Live testing depends on the tools available in your Claude Code environment and the scope you explicitly authorize. Generated findings still require review against actual evidence.

Built for Claude Code. This is an independent project, not an official Anthropic product.

## Contents

- [Quick start](#quick-start)
- [Commands and workflow](#commands-and-workflow)
- [Review coverage](#review-coverage)
- [Evidence and validation statuses](#evidence-and-validation-statuses)
- [Repository layout](#repository-layout)
- [Local checks and evaluation cases](#local-checks-and-evaluation-cases)
- [Landing page](#landing-page)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Security and scope](#security-and-scope)
- [License](#license)

## Quick start

### Requirements

- Git and Claude Code with plugin support, installed and authenticated.
- An owned application, approved lab, or target covered by explicit written authorization.
- Approved test identities and synthetic records for account, role, or tenant comparisons.

PowerShell and [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) are needed only for the repository validation script. Python is optional, for previewing the landing page.

### Load the plugin locally

```bash
git clone https://github.com/zetachess/Claude-BountySignal.git
cd Claude-BountySignal
claude --plugin-dir .
```

This loads the plugin for that Claude Code session. To use it while working in another directory, launch Claude Code there with `--plugin-dir` pointing to the absolute path of this clone. See the [official plugin documentation](https://code.claude.com/docs/en/plugins) for local loading and plugin management.

Inside Claude Code, type `/claude-bountysignal:` to find the plugin commands. Begin with:

```text
/claude-bountysignal:auth-audit
```

Then provide the target, exact scope, available test identities, allowed actions, testing window, and constraints. When authorization or scope is incomplete, the workflow stays at the planning stage.

## Commands and workflow

Commands use the `claude-bountysignal` namespace from the [plugin manifest](.claude-plugin/plugin.json).

| Command | Provide | Expected output |
| --- | --- | --- |
| `/claude-bountysignal:auth-audit` | Scope, entry points, identities, roles, and constraints | Identity-surface map, comparison matrix, prioritized hypotheses, and stop conditions |
| `/claude-bountysignal:auth-validate` | An observation, reproduction steps, and redacted evidence | Expected versus observed behavior, false-positive checks, supported impact, and validation status |
| `/claude-bountysignal:auth-report` | A validated finding and its evidence | A report following the [vulnerability report template](templates/vulnerability-report.md) |

The [`hunt-auth-bypass` skill](skills/hunt-auth-bypass/SKILL.md) supplies the shared review method for authentication, sessions, recovery, tokens, and access controls.

### Example: plan an authorized lab review

Run `/claude-bountysignal:auth-audit`, then supply context such as:

```text
Target: my locally hosted practice application.
Scope: the invoice API in this lab only, during this session.
Identities: approved test accounts A and B, both with the basic-user role.
Data: synthetic invoices owned by those accounts.
Allowed actions: read-only comparisons of the documented invoice endpoint.
Constraints: no third-party requests, no credential guessing, no unrelated data.
Task: produce a review plan and evidence checklist before making any requests.
```

After performing an approved comparison, give `/claude-bountysignal:auth-validate` the exact steps, expected ownership rule, and minimal redacted request/response evidence. A hypothesis without the necessary comparison should remain `needs more evidence`.

Use `/claude-bountysignal:auth-report` once the finding is validated. The report should include preconditions, test roles, reproduction steps, expected and observed behavior, demonstrated impact, remediation, and retest criteria. Missing facts must stay explicit.

## Review coverage

| Area | Review focus |
| --- | --- |
| Authentication | Login, registration, logout, and account recovery |
| Session integrity | Creation, rotation, expiry, revocation, and identity changes |
| Step-up controls | MFA and recovery-flow consistency |
| Tokens | JWT and bearer-token handling hypotheses |
| Authorization | Roles, tenants, protected actions, and object ownership (IDOR/BOLA) |
| Entry-point boundaries | Differences across routes, supported methods, gateways, and backends |
| Reporting | Minimal redacted evidence, defensible status, and server-side remediation |

Coverage describes the review instructions, not a guarantee that every issue will be detected.

## Evidence and validation statuses

Compare the same operation across authorized identities or session states. Record the expected control, observed result, and evidence reference for each comparison. A status code alone does not establish impact.

The shared skill and synthetic cases use four outcomes:

| Status | Meaning |
| --- | --- |
| `confirmed` | Reproducible unauthorized behavior supported by redacted evidence |
| `not reproducible` | The expected control held during the comparison |
| `needs more evidence` | A required comparison, response, or impact proof is missing |
| `out of scope` | The target, account, action, or data is not authorized |

Keep only the evidence needed to establish the result. Redact cookies, bearer tokens, credentials, email addresses, and personal data. Do not claim account takeover or data exposure unless the evidence supports it.

## Repository layout

```text
.claude-plugin/plugin.json       Plugin name, version, and metadata
commands/                       Audit, validation, and reporting commands
skills/hunt-auth-bypass/         Shared review method and scope boundaries
templates/vulnerability-report.md
                                Finding and retest template
evals/cases/                    Seven synthetic reasoning cases
scripts/validate.ps1             Structural and secret-pattern checks
site/                           Static landing page and its assets
assets/                         README and promotional images
docs/social-preview.md          Social preview guidance
vercel.json                     Static site deployment configuration
```

## Local checks and evaluation cases

From the repository root, with PowerShell and `rg` available:

```powershell
.\scripts\validate.ps1
```

The script checks manifest identity and version, required files, stale project names, selected secret patterns, and the presence of at least seven evaluation cases. Expected success output:

```text
Claude-BountySignal validation passed. Evaluation cases: 7.
```

These are structural checks. The script does not run Claude Code, execute the scenarios, or verify model behavior; its secret patterns are not a comprehensive secret scan.

The [synthetic evaluation cases](evals/cases/README.md) cover:

- [Unauthenticated access](evals/cases/unauthenticated-access.md)
- [Object-level authorization](evals/cases/object-authorization.md)
- [Role escalation](evals/cases/role-escalation.md)
- [Invalid session reuse](evals/cases/invalid-session.md)
- [False positives](evals/cases/false-positive.md)
- [Insufficient evidence](evals/cases/insufficient-evidence.md)
- [Out-of-scope targets](evals/cases/out-of-scope.md)

For a manual evaluation, give Claude the scenario from a case, then compare its response with the case's expected result and required guard. Check that it distinguishes facts from assumptions and does not invent evidence. No live target is needed.

## Landing page

The static site lives in [`site/`](site/). To preview it locally with Python:

```bash
python -m http.server 4173 --bind 127.0.0.1 --directory site
```

Open [localhost:4173](http://127.0.0.1:4173). This previews the website; it does not load the plugin.

For deployment, import the repository into Vercel. The included [`vercel.json`](vercel.json) selects `site` as the output directory and enables clean URLs. The site requires no framework build step.

## Roadmap

Planned directions, not current features:

- Broader session, OAuth/OIDC, JWT, and MFA review patterns.
- More regression cases for false positives and incomplete evidence.
- A controlled practice-lab package.
- Possible Burp and standalone CLI integrations after the core workflow stabilizes.
- Optional translations, with English as the source of truth.

See [open issues](https://github.com/zetachess/Claude-BountySignal/issues) and the [changelog](CHANGELOG.md) for project discussions and recorded changes.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md), use synthetic examples, and explain the preconditions, expected control, safe validation approach, evidence requirements, and remediation direction for each new check. Run the local validation script before submitting a pull request.

Report ordinary bugs or suggest improvements through [GitHub issues](https://github.com/zetachess/Claude-BountySignal/issues). Follow the security policy for vulnerabilities in the project itself.

## Security and scope

Use this plugin only on owned systems, approved labs, or assets covered by explicit written authorization. Do not obtain or guess credentials, access unrelated accounts, evade rate limits, collect unnecessary personal data, or expand scope based on a discovered redirect, hostname, email address, or third-party service.

Read [SECURITY.md](SECURITY.md) before testing. Report vulnerabilities in Claude-BountySignal privately to the repository maintainers; keep sensitive target details and live credentials out of public issues.

## License

[MIT](LICENSE).

<p align="right"><a href="#readme-top">Back to top</a></p>
