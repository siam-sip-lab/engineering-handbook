# Commit messages

Standard: [Conventional Commits 1.0](https://www.conventionalcommits.org).

## Format

```
<type>(<optional scope>): <summary>

<optional body: why, not how>

<optional footer: Closes #12, BREAKING CHANGE: ...>
```

Types are the same as in [branching](branching.md): `feat`, `fix`, `docs`,
`refactor`, `test`, `ci`, `chore`.

## Rules for the summary line

- Imperative mood: "add", not "added" or "adds".
- Lowercase start, no full stop at the end.
- 72 characters or fewer.
- Says **what changed**, readable without opening the diff.

## Examples

| Good | Bad | Why bad |
| --- | --- | --- |
| `feat(cli): add --format json option` | `update` | says nothing |
| `fix(stock): round quantities down, not up` | `fixed bug` | which bug? past tense |
| `docs(adr): add ADR-0002 use GitHub Flow` | `Docs: Added ADR.` | capitals, past tense, full stop |
| `refactor: extract config loader` | `wip` | fine inside a branch, never as a PR title |

## Breaking changes

Add `!` after the type and explain in the footer. This means a **MAJOR** version
bump (see [versioning](versioning.md)).

```
feat(config)!: rename threshold to min_stock

BREAKING CHANGE: config files using `threshold` must be updated.
```

## Pull request titles

We squash-merge ([ADR-0003](../adr/0003-merge-strategy.md)), so the **PR title
becomes the commit message on `main`**. The PR title must follow this standard.
Commits inside your branch can be informal ("wip" is fine there).
