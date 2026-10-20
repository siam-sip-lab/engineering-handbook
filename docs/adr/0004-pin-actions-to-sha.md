# ADR-0004: Pin GitHub Actions to full commit SHAs

- Status: Accepted
- Date: 2026-10-20
- Deciders: Max (platform team)
- Related: ADR-0001 (decision 11, deferred to M5)

## Context

Workflows run third-party code: every `uses: owner/action@ref` downloads and runs
someone else's repository with access to our checkout and token.

A tag such as `@v7` is a **movable pointer**. The action's owner, or anyone who
takes over their account, can move the tag to new code at any time, and every
workflow using it runs the new code on its next run without any change on our side.
Real supply-chain attacks have worked exactly this way.

A full commit SHA (40 hex characters) is **immutable**: it always means the same code.

## Options considered

| Option | Example | Why chosen / not chosen |
| --- | --- | --- |
| Major tag | `actions/checkout@v7` | Convenient, gets fixes automatically, but runs whatever the tag points to today. |
| Exact version tag | `actions/checkout@v7.0.1` | Looks fixed but is still a tag and can be moved. |
| **Full commit SHA + version comment (chosen)** | `actions/checkout@3d3c42e…  # v7.0.1` | Immutable; the comment keeps it readable; Dependabot updates SHA and comment together. |

## Decision

1. **Every action from outside the org is pinned to a full commit SHA**, with the
   version as a trailing comment.
2. **Only versions released at least two weeks ago** are pinned, so a newly
   published malicious release has time to be caught by the community first.
3. **Dependabot (`github-actions` ecosystem) proposes updates** weekly; updates go
   through a normal pull request and CI like any other change.
4. **Reusable workflows inside the org** (`siam-sip-lab/.github/...@main`) may use
   `@main`: they are our own code, protected by `main-protection` (PR + review +
   signed commits), so a change to them is already reviewed.
5. **The org setting "Require actions to be pinned to a full-length commit SHA"
   is enabled** so the rule is enforced by the platform, not by review alone.
6. Tools installed inside workflows are pinned to exact versions too
   (e.g. `ruff==0.16.10`), and the same version is used locally.

## Consequences

### Positive

- A compromised or re-tagged action cannot silently change what our CI runs.
- Every change to the code CI executes appears as a reviewable pull request.

### Negative

- SHAs are unreadable on their own; the version comment must be kept accurate
  (Dependabot does this).
- Security fixes in actions arrive only when we merge the Dependabot PR.
- Contributors copying examples from the internet (`@v4`) will see CI fail until
  they pin; documented in the contributing guide.

### When to revisit

- If GitHub introduces immutable releases for actions that make tags trustworthy.
