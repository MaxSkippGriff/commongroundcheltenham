#!/bin/bash
# One-off: publish commongroundcheltenham to GitHub Pages.
set -u
REPO=MaxSkippGriff/commongroundcheltenham
cd "$(dirname "$0")" || exit 1

step() { printf '\n\033[1m== %s\033[0m\n' "$1"; }
ok()   { printf '   \033[32mOK\033[0m  %s\n' "$1"; }
die()  { printf '   \033[31mFAILED\033[0m  %s\n' "$1"; exit 1; }

step "1/5  Where am I"
pwd
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not a git repo"
ok "git repo found"

step "2/5  Commit the GitHub Pages files"
git add -A
if git diff --cached --quiet; then
  ok "nothing new to commit"
else
  git commit -m "Switch hosting to GitHub Pages" || die "commit failed"
  ok "committed"
fi

step "3/5  Push to GitHub"
git push origin main || die "push failed - check: gh auth status"
ok "pushed"

step "4/5  Make the repository public"
# Done via the API: the gh CLI flag for this needs a newer gh than 2.22.
if [ "$(gh repo view "$REPO" --json isPrivate --jq .isPrivate)" = "true" ]; then
  gh api -X PATCH "repos/$REPO" -F private=false >/dev/null || die "could not change visibility"
  sleep 2
  [ "$(gh repo view "$REPO" --json isPrivate --jq .isPrivate)" = "false" ] \
    || die "repo still private"
  ok "now public"
else
  ok "already public"
fi

step "5/5  Turn on GitHub Pages"
if gh api "repos/$REPO/pages" >/dev/null 2>&1; then
  ok "Pages already enabled"
else
  gh api -X POST "repos/$REPO/pages" -f 'source[branch]=main' -f 'source[path]=/' >/dev/null \
    || die "could not enable Pages"
  ok "Pages enabled"
fi

printf '\n\033[1mDone.\033[0m Give it about a minute, then check:\n'
printf '  https://maxskippgriff.github.io/commongroundcheltenham/\n\n'
printf 'Build status:\n'
gh api "repos/$REPO/pages/builds/latest" --jq '"  " + .status + "  " + (.error.message // "no errors")' 2>/dev/null \
  || printf '  (first build still queued)\n'
