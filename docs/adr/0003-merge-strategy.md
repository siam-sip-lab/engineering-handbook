# ADR-0003: Squash and merge as the only merge method

- Status: Accepted
- Date: 2026-10-17
- Deciders: Max (platform team)
- Related: ADR-0002

## Context

GitHub offers three ways to land a pull request on `main`. The choice decides what
`main`'s history looks like for everyone, forever. Inside a branch, developers commit
often ("wip", "fix typo", "address review"), and that is fine while working. The
question is which of those commits should become permanent history on `main`.

What we need from `main`'s history:

- Readable as a changelog with `git log --oneline main`.
- One feature can be reverted in one step.
- `git bisect` lands only on states that were reviewed and passed CI.
- Commit messages follow Conventional Commits, so release notes can be generated.

## Options considered

| Criterion | Merge commit | **Squash and merge** | Rebase and merge |
| --- | --- | --- | --- |
| Readable history | Noisy: every WIP commit plus a merge commit | One commit per PR | Readable only if every commit is clean |
| Revert one feature | `git revert -m 1 <merge>` | `git revert <sha>` | Must revert several commits |
| `git bisect` | Can land on half-finished WIP commits | Every commit on `main` passed review and CI | Can land on commits never tested alone |
| What is lost | Nothing | Individual branch commits (still visible in the PR) | Original commit SHAs |
| Discipline needed | Low | Low | High: every commit must be meaningful |

## Decision

1. **Allow only "Squash and merge".** Disable "Allow merge commits" and
   "Allow rebase merging" in every repository's settings, so the standard is enforced
   by the system, not by memory.
2. **The pull request title becomes the commit message on `main`,** so it must follow
   Conventional Commits (`feat(scope): summary`). From M5, CI checks the title.
3. **Squash commit message default: "Pull request title and description".** The
   description explains the why; it becomes the commit body.
4. **Automatically delete head branches** after merge.
5. **Keep pull requests small** (about 400 changed lines or fewer), because each one
   becomes a single commit. Split larger work into stacked pull requests.
6. These repository settings are not copied by templates, so they are part of
   `new-repo-checklist.md` (M3).

## Consequences

### Positive

- `main` reads as a list of features and fixes, one line each.
- Reverting a feature is one commit.
- Every commit on `main` passed review and CI, so `bisect` results are trustworthy.
- Release notes can be generated from commit messages (M8).
- Work-in-progress commits inside a branch stay low-stakes; developers can commit freely.

### Negative

- Individual commits from the branch disappear from `main`. They remain in the pull
  request on GitHub, but not in `git log`.
- A large pull request becomes one large commit that is harder to review, revert or
  bisect. Mitigated by the size rule.
- Stacked pull requests need `git rebase --onto` after the base PR is squash-merged
  (practised in M7).
- Merging from the command line must also squash; `git merge` into `main` is blocked
  by rulesets (M3).

### When to revisit

- If the team grows and consistently writes clean, meaningful commits, consider
  allowing "Rebase and merge" for pull requests where individual commits add value.
