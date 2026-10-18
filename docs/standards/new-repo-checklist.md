# New repository checklist

A template copies **files** only. Settings, team access and rulesets are **not**
copied, so every new repository needs these steps.

## 1. Create from the template

```bash
cd /c/dev
gh repo create siam-sip-lab/<name> --public --template siam-sip-lab/repo-template \
  --description "<one line: what it does>" --clone
```

Follow the [repository naming](repo-naming.md) standard.

## 2. Apply settings and team access

```bash
bash /c/dev/engineering-handbook/scripts/apply-repo-standards.sh \
  siam-sip-lab/<name> platform:admin developers:push everyone:pull
```

This sets squash-only merging ([ADR-0003](../adr/0003-merge-strategy.md)),
Dependabot alerts, secret scanning, push protection
([ADR-0001](../adr/0001-adopt-github-organization.md)) and team access.
Every line should print `ok`.

## 3. Protect `main`

Settings → Rules → Rulesets → **Import a ruleset** → `rulesets/main-protection.json`
from this handbook. (Until that file exists, create the ruleset by hand as in M3.)

## 4. Fill in the placeholders

- `README.md`: what / quick start / owners
- `.github/CODEOWNERS`: adjust if another team owns the code

## 5. Check

- [ ] `git push origin main` is **rejected**
- [ ] New issue shows the org issue forms
- [ ] Settings → General shows only "Allow squash merging"
