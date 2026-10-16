# Branching

Model: **GitHub Flow** — see [ADR-0002](../adr/0002-branching-model.md).

## Rules

1. `main` is always releasable. Never commit to it directly; use a pull request.
2. One issue, one branch, created from the latest `main`.
3. A branch lives at most **3 working days**. Split bigger work into smaller PRs.
4. Keep your branch current with **rebase**, not merge.
5. Branches are deleted automatically after merge.

## Branch names

`<type>/<issue-number>-<short-description>` — lowercase, words joined by `-`.

| Type | Use for |
| --- | --- |
| `feat` | new capability |
| `fix` | bug fix |
| `docs` | documentation only |
| `refactor` | code change with no behaviour change |
| `test` | adding or fixing tests |
| `ci` | CI / workflow changes |
| `chore` | maintenance (dependencies, config) |

| Good | Bad | Why bad |
| --- | --- | --- |
| `feat/12-low-stock-alert` | `max-branch` | no type, no issue, says nothing |
| `fix/31-rounding-error` | `fix` | not unique, no context |
| `docs/40-onboarding-guide` | `Feature/LowStock_Alert` | capitals, underscores, no issue |

## Daily commands

```bash
git switch main && git pull                 # start from latest main
git switch -c feat/12-low-stock-alert       # new branch
# ...work and commit...
git push -u origin HEAD                     # first push
gh pr create --draft --fill                 # open draft PR early

# main moved on while you were working:
git fetch origin
git rebase origin/main
git push --force-with-lease                 # never plain --force
```

## Never

- Rebase `main`, or a branch someone else is working on, without agreement.
- Use `git push --force` (use `--force-with-lease`).
- Keep a branch open "until it's all done".
