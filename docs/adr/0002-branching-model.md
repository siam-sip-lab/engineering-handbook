# ADR-0002: Use GitHub Flow as the branching model

- Status: Accepted
- Date: 2026-10-17
- Deciders: Max (platform team)
- Related: ADR-0001, ADR-0003

## Context

- The IT team has 4 people. The first repos are internal scripts, configuration,
  small tools and this handbook.
- Work ships continuously: a change is used as soon as it is merged. There is one
  production version at a time; we do not support several released versions in parallel.
- CI is being introduced (M5). Until it is mature, `main` is protected mainly by
  pull requests and review.
- Most staff are new to Git. The model must be simple enough to teach in one session.

## Options considered

| Option | How it works | Why chosen / not chosen |
| --- | --- | --- |
| Git Flow | Long-lived `main` + `develop`, plus `feature/`, `release/`, `hotfix/` branches | Built for versioned products with scheduled releases and several supported versions. Too much ceremony for a 4-person team shipping continuously; `develop` drifts from `main` and doubles the merge work. |
| Trunk-based development | Everyone commits to `main` directly or via branches living less than a day, hiding unfinished work behind feature flags | Fastest flow, but needs strong automated tests and feature-flag discipline we do not have yet. |
| **GitHub Flow (chosen)** | `main` is always releasable; each change gets a short-lived branch and a pull request; merge after CI and review | Simple, matches GitHub's defaults and tooling, and works with the review and CI rules we are building. |

## Decision

1. **`main` is always releasable.** Anything merged must be safe to use immediately.
2. **One issue, one short-lived branch,** created from the latest `main`.
   Naming: `<type>/<issue#>-<short-desc>`, e.g. `feat/12-low-stock-alert`.
   Types follow Conventional Commits: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`.
3. **Branches live at most 3 working days.** Larger work is split into smaller pull
   requests (stacked if needed), not kept on one long branch.
4. **Every change reaches `main` through a pull request** with passing CI and review
   (enforced by rulesets from M3).
5. **Keep branches current by rebasing on `origin/main`,** then push with
   `--force-with-lease`. Never rebase `main` itself or a branch someone else is
   working on without agreement.
6. **Delete the branch after merge** (automatic, see ADR-0003).
7. **Releases are tags on `main`** (`vMAJOR.MINOR.PATCH`), not branches.
8. **Exception — patching an old release:** if a fix must ship while `main` holds
   unreleased work, create `release/X.Y.x` from the release tag, cherry-pick the fix,
   tag the patch release, and delete the branch afterwards. This is an exception,
   not a second workflow.

## Consequences

### Positive

- One rule set for everyone: branch, pull request, merge. Easy to teach and audit.
- Small, frequent merges mean fewer and smaller conflicts.
- No `develop` branch to keep in sync with `main`.

### Negative

- Since `main` is always releasable, unfinished work cannot be merged "to finish
  later". It must be split or hidden behind a configuration switch.
- Quality depends on CI and review. Until CI is in place (M5), reviewers carry more
  responsibility.
- No staging branch: testing happens on the pull request branch before merge.

### When to revisit

- Move toward **trunk-based development** when automated tests are reliable and the
  team is comfortable with feature flags.
- Adopt **long-lived release branches** if the company starts shipping versioned
  software that customers keep using after newer versions are released.
