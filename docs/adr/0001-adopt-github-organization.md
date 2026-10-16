# ADR-0001: Adopt a GitHub Organization with least-privilege defaults

- Status: Accepted
- Date: 2026-10-16
- Deciders: Max (Org Owner, platform team)
- Scope: `siam-sip-lab` sandbox organization, the proving ground for Siam Sip Co.

## Context

Siam Sip Co. has about 80 staff and a 4-person IT team. Scripts, documents and
configuration live in shared folders, named like `report_final_v3_ใช้อันนี้.py`.
This causes four concrete problems:

1. **No reliable history.** Nobody can say which version is running or roll back safely.
2. **No review.** Changes go straight into the shared copy with no second pair of eyes.
3. **No accountability.** There is no record of who changed what, or when.
4. **Knowledge leaves with people.** Files owned by one person's account disappear
   or become inaccessible when that person leaves.

Management asked IT to introduce version control company-wide, proven first in a
sandbox. The sandbox must use the same structure we would recommend for the real
company, so decisions made here carry over.

## Options considered

| Option | Why not chosen / why chosen |
| --- | --- |
| Keep shared folders (status quo) | Solves none of the four problems above. |
| Use Google Drive / SharePoint version history | Keeps old file versions, but has no branching, no code review, no CI, and no merge of parallel edits. Fine for documents, not for code and config. |
| Repositories under personal GitHub accounts | Each repo belongs to one person. No teams, no base permissions, no org-wide policies or audit log. Fails problem 4 directly. |
| Another platform (GitLab, Azure DevOps) | Viable. GitHub chosen for the largest ecosystem, widest familiarity among new hires, and free public-repo features used in this sandbox. Revisit if the company standardizes on a Microsoft stack. |
| **GitHub Organization (chosen)** | Company-owned container for repos, with teams, central policies, and an audit log. |

## Decision

Each item follows: **setting → because → accepting**.

### Identity and access

1. **Require 2FA for all members, secure methods only** (authenticator app, passkey,
   security key, GitHub Mobile; no SMS).
   Because a leaked password alone would give full access to every repo, and SMS codes
   can be stolen by taking over a phone number (SIM swap).
   Accepting that members who lose their device must recover with their own recovery codes.

2. **Base permission: Read.**
   Because most people need to see code, not change it. Write access is granted only
   where needed, through teams.
   Accepting that new members cannot contribute until added to the right team.

3. **Grant access through teams, never to individuals.** Teams: `platform` (admin of
   shared standards repos), `developers` (write in product repos), `everyone` (read).
   Because joiners, movers and leavers are then handled in one place, and access is
   reviewable at a glance.
   Accepting a small setup cost per new repo (assign teams).

4. **Only owners can change repository visibility, delete or transfer repositories,
   or delete issues. Forking of private repositories is disabled.**
   Because these actions are irreversible or can expose company data in one click
   (private → public, transfer outside the org).
   Accepting that owners become a bottleneck for these rare actions.

5. **App access requests: members only.**
   Because people outside the org should not be able to request apps that read org data.

### Repository defaults

6. **Default branch: `main`.**
   Because it matches GitHub's default and current industry convention, avoiding
   name mismatches between local and remote.

7. **Replace GitHub's default labels with a prefixed taxonomy:** `type:feature`,
   `type:bug`, `type:docs`, `type:chore`, `priority:high`, `needs-triage`,
   plus `good first issue`.
   Because prefixes group labels by meaning, make filtering predictable, and will drive
   release-note categories later. Resolution labels (`duplicate`, `wontfix`,
   `invalid`) are dropped because GitHub's built-in close reasons record the outcome,
   and `question` is covered by `needs-triage`.
   Accepting that people used to GitHub's defaults must learn the new names.

### GitHub Actions

8. **Allow only actions created by GitHub, actions from Marketplace verified creators,
   and actions defined inside this org.**
   An action is someone else's code that runs inside our repository with access to
   our files. Allowing every action means trusting every author on the internet with
   that access.
   Accepting that some useful community actions will be blocked until reviewed and
   explicitly allowed (expected in M5).

9. **Default `GITHUB_TOKEN` permission: read-only. Actions may not create or approve
   pull requests.**
   Because a compromised or buggy workflow should not be able to change code, and a bot
   must not be both author and approver; otherwise required reviews lose their meaning.
   Accepting that workflows needing write access must request it explicitly in YAML.

10. **Self-hosted runners: disabled.**
    Because we use GitHub-hosted runners, and a self-hosted runner attached to a public
    repo could run code from an outsider's pull request on our own machine.

11. **Pinning actions to full commit SHAs: deferred.** To be decided in M5 when CI is
    written, recorded in a separate ADR.

### Security scanning

12. **Do not use the org-level security configuration.** Enable Dependabot alerts,
    secret scanning and push protection per repository instead, and enable
    "Push protection for yourself" on owner accounts.
    Because the org-level configuration requires starting a paid trial with a credit
    card, while all sandbox repos are public and get these features free.
    Accepting the risk of forgetting a new repo, mitigated by `new-repo-checklist.md` (M3).

### Planning and identity

13. **Org-level project `Siam Sip Roadmap` (public)** for planning across repos.
14. **Org profile marked as a sandbox of a fictional company,** so nobody mistakes it
    for a real business.

## Consequences

### Positive

- Every change has a history, an author and, from M3, a review.
- Access is least-privilege by default and managed through three teams.
- Irreversible and data-exposing actions are limited to owners.
- Third-party code in CI is restricted, and CI cannot approve its own changes.
- Every org-level change is recorded in the audit log (this already caught one
  misconfiguration during setup: Actions had been allowed to approve PRs).

### Negative

- More friction for newcomers: 2FA setup, team membership requests.
- Some community actions blocked until reviewed.
- Security scanning depends on a per-repo checklist instead of a central default.
- **Bus factor of 1:** the sandbox has a single owner.

### Limits found on the Free plan (input for the M11 proposal)

Observed as unavailable or locked in the sandbox. Verify against GitHub's current
pricing page before the proposal.

- Restricting members from creating **public** repositories (option locked).
- **Private** GitHub Pages sites (option locked).
- SAML single sign-on, team synchronization with an identity provider, IP allow list.
- Org-level security configuration (requires paid trial).
- Audit log covers the current month plus the previous six; longer retention needs export.

### Requirements before a real-company rollout

- At least **two owners**, using company-controlled accounts.
- Private repositories, which means a paid plan to keep rulesets and security
  scanning enforced.
- A documented access-request and offboarding process (M10).
- A recovery process for members who lose their 2FA device.

## Follow-ups

- ADR-0002: branching model (M2)
- ADR-0003: merge strategy (M2)
- `new-repo-checklist.md` including security settings (M3)
- ADR on action SHA pinning (M5)
- `access-policy.md` (M10)
- Adoption proposal (M11)
