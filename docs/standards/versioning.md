# Versioning

Standard: [Semantic Versioning 2.0.0](https://semver.org) — `MAJOR.MINOR.PATCH`.

## When to bump

| Part | Bump when | Example | Commit type that triggers it |
| --- | --- | --- | --- |
| MAJOR | existing users must change something | config format changes, old files stop working | `feat!` / `BREAKING CHANGE` |
| MINOR | new capability, old usage still works | add `--format json` | `feat` |
| PATCH | bug fix, no new capability | fix rounding of stock quantities | `fix` |

`docs`, `refactor`, `test`, `ci`, `chore` alone do not require a release.

## Rules

1. Versions are **tags on `main`**: `v0.1.0`, `v1.4.2` (lowercase `v`).
2. Tags are **annotated and signed**: `git tag -s v0.2.0 -m "..."`.
3. `0.y.z` means early development: anything may change. Release `1.0.0` when the
   tool is relied on by people outside the team.
4. A published tag is **never moved or deleted**. If a release is wrong, publish
   a new PATCH version instead.
5. Every release has notes (generated from PR titles, see M8).

## Release in short

```bash
git switch main && git pull
git tag -s v0.2.0 -m "Sprint 2"
git push origin v0.2.0
gh release create v0.2.0 --generate-notes
```
