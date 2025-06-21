#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------------------
# setup-branches.sh
#   Initialize Gitflow (manually) or Mainline (trunk-based) branching
#   on a repo—even on Windows where `git flow init -m` may not work.
#
# Usage:
#   ./setup-branches.sh gitflow
#   ./setup-branches.sh mainline
# -------------------------------------------------------------------

usage() {
  cat <<EOF
Usage: $(basename "$0") <pattern>

Patterns:
  gitflow    Initialize Gitflow branches (main + develop + feature/release/hotfix)
  mainline   Ensure only a 'main' trunk branch (trunk-based development)
EOF
  exit 1
}

# 1) one arg only
[[ $# -eq 1 ]] || usage
pattern=$1

# 2) must be in a git repo
if ! git rev-parse --git-dir &>/dev/null; then
  echo "Error: not a git repository." >&2
  exit 1
fi

# 3) must have origin
if ! git remote get-url origin &>/dev/null; then
  echo "Error: remote 'origin' is not configured.  Please 'git remote add origin <URL>' first." >&2
  exit 1
fi

# 4) rename master → main (if present)
rename_master_to_main() {
  if git show-ref --quiet refs/heads/master; then
    echo "🔀 Renaming 'master' → 'main'…"
    git branch -m master main
    git push origin :master main
    git push --set-upstream origin main
  else
    git checkout main 2>/dev/null || git checkout -b main
    git push --set-upstream origin main
  fi
}

case "$pattern" in

  gitflow)
    echo "🏁 Bootstrapping Gitflow (manual init)…"

    # (a) rename master→main & push
    rename_master_to_main

    # (b) create (and switch to) develop branch off main
    if ! git show-ref --quiet refs/heads/develop; then
      echo "➜ Creating 'develop' branch from 'main'…"
      git checkout -b develop main
      git push -u origin develop
    else
      echo "➜ 'develop' already exists; checking it out…"
      git checkout develop
    fi

    # (c) write Gitflow config into .git/config
    git config gitflow.branch.master   main
    git config gitflow.branch.develop  develop
    git config gitflow.prefix.feature  feature/
    git config gitflow.prefix.release  release/
    git config gitflow.prefix.hotfix   hotfix/
    git config gitflow.prefix.support  support/
    git config gitflow.prefix.versiontag v

    echo "⚙️  Manual Gitflow settings applied."

    # (d) now demo one feature / release / hotfix
    read -rp "Enter a feature name (e.g. awesome-feature): " FEATURE
    git flow feature start "$FEATURE"
    git flow feature finish "$FEATURE"

    read -rp "Enter a release version (e.g. 1.0.0): " RELEASE
    git flow release start "$RELEASE"
    git flow release finish "$RELEASE"

    read -rp "Enter a hotfix version (e.g. 1.0.1): " HOTFIX
    git flow hotfix start "$HOTFIX"
    git flow hotfix finish "$HOTFIX"

    # (e) push everything
    echo "📤 Pushing branches & tags to origin…"
    git push origin --all
    git push origin --tags

    echo "✅ Manual Gitflow model bootstrapped."
    ;;

  mainline)
    echo "🏁 Setting up Mainline (trunk) model…"

    # rename master→main & push
    rename_master_to_main

    echo ""
    echo "✅ Mainline (trunk-based) model ready."
    echo "   Develop directly on 'main' and create short-lived feature branches:"
    echo "     git checkout -b feature/xyz main"
    ;;

  *)
    usage
    ;;
esac
