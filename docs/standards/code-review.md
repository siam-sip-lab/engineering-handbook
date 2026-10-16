# Code review

References: [Google Engineering Practices](https://google.github.io/eng-practices/),
[Conventional Comments](https://conventionalcomments.org).

**Goal:** approve when the change makes the codebase better, not when it is perfect.

## Author checklist (before requesting review)

- [ ] PR is small: about **400 changed lines** or fewer.
- [ ] Title follows the [commit message standard](commit-messages.md).
- [ ] Description filled in from the template, with `Closes #<issue>`.
- [ ] CI is green.
- [ ] You reviewed your own diff in "Files changed" first.

## Reviewer: what to check, in order

1. **Design** — is this the right approach?
2. **Functionality** — does it do what the issue asks? Run it locally:
   `gh pr checkout <number>`.
3. **Complexity** — could it be simpler?
4. **Tests** — are the important cases covered?
5. **Naming** — are names clear?
6. **Comments / docs** — is the *why* explained where needed?
7. **Style** — leave to linters; do not argue about formatting by hand.

## Comment labels (Conventional Comments)

| Label | Meaning | Blocks merge? |
| --- | --- | --- |
| `issue (blocking):` | must be fixed | yes |
| `suggestion:` | proposed improvement, ideally as a suggestion block | no, unless marked blocking |
| `question:` | need to understand before approving | until answered |
| `nitpick (non-blocking):` | tiny preference | no |
| `praise:` | something done well | no |

Example: `issue (blocking): this query counts returns as sales. Filter on status = 'sold'.`

## Etiquette and timing

- Comment on the code, never the person.
- First response within **1 working day**.
- Author replies to every comment ("Done in abc123" or a reason), then resolves it.
- The **author** merges after approval and green CI.
