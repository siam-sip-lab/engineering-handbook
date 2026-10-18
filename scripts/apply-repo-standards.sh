#!/usr/bin/env bash
# Apply org repository standards that templates cannot copy.
# Usage: scripts/apply-repo-standards.sh <org>/<repo> [team:permission ...]
#   permission = pull | triage | push | maintain | admin
# Example:
#   scripts/apply-repo-standards.sh siam-sip-lab/stock-checker platform:admin developers:push everyone:pull
set -uo pipefail
repo="${1:?usage: apply-repo-standards.sh <org>/<repo> [team:permission ...]}"; shift
org="${repo%%/*}"
ok ()   { echo "  ok   $1"; }
warn () { echo "  WARN $1"; }

echo "Applying standards to $repo"

# Merge settings (ADR-0003): squash only, PR title + description, auto-delete branches
gh repo edit "$repo" --enable-squash-merge --enable-merge-commit=false \
  --enable-rebase-merge=false --delete-branch-on-merge >/dev/null \
  && ok "squash merge only, auto-delete head branches" || warn "merge settings"
gh api -X PATCH "repos/$repo" -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY >/dev/null \
  && ok "squash message = PR title and description" || warn "squash message"

# Security (ADR-0001 #12): free on public repositories
gh api -X PUT "repos/$repo/vulnerability-alerts" >/dev/null \
  && ok "Dependabot alerts" || warn "Dependabot alerts"
sec='{"security_and_analysis":{"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}}'
echo "$sec" | gh api -X PATCH "repos/$repo" --input - >/dev/null \
  && ok "secret scanning + push protection" || warn "secret scanning (public repos only)"

# Team access (ADR-0001 #3): always through teams, never individuals
for tp in "$@"; do
  team="${tp%%:*}"; perm="${tp##*:}"
  gh api -X PUT "orgs/$org/teams/$team/repos/$repo" -f permission="$perm" >/dev/null \
    && ok "team $team = $perm" || warn "team $team (needs: gh auth refresh -s admin:org)"
done

echo "Manual step left: ruleset on main (see docs/standards/new-repo-checklist.md)"
