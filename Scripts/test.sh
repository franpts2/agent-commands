#!/bin/sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TEMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/agent-docs-commands.XXXXXX")
REPOSITORY=
WORKTREE=

cleanup() {
    if [ -n "$REPOSITORY" ] && [ -n "$WORKTREE" ] && [ -d "$REPOSITORY/.git" ]; then
        git -C "$REPOSITORY" worktree remove --force "$WORKTREE" >/dev/null 2>&1 || true
    fi
    # Local Git observers may finish writing notes just after the test exits.
    attempts=0
    while [ -e "$TEMP_ROOT" ] && [ "$attempts" -lt 10 ]; do
        rm -rf -- "$TEMP_ROOT" >/dev/null 2>&1 || true
        attempts=$((attempts + 1))
        [ ! -e "$TEMP_ROOT" ] || sleep 1
    done
}

trap cleanup EXIT HUP INT TERM

HOME_DIR="$TEMP_ROOT/home"
XDG_DIR="$TEMP_ROOT/config"
mkdir -p -- "$HOME_DIR" "$XDG_DIR"

sh -n "$ROOT/Scripts/install.sh"
sh -n "$ROOT/Scripts/uninstall.sh"
sh -n "$ROOT/Scripts/test.sh"

for command_file in "$ROOT"/commands/*.md; do
    grep -Fq -- 'agent-docs-commands:managed' "$command_file"
    grep -Fq -- '$ARGUMENTS' "$command_file"
done

grep -Fq -- '`status: draft`' "$ROOT/commands/write-doc.md"
grep -Fq -- '`status: reviewed`' "$ROOT/commands/read-docs.md"
grep -Fq -- '`explanation`' "$ROOT/commands/write-doc.md"
grep -Fq -- '`implementation`' "$ROOT/commands/write-doc.md"
grep -Fq -- 'stop after every iteration' "$ROOT/commands/write-doc.md"
grep -Fq -- 'wait for explicit user approval' "$ROOT/commands/write-doc.md"
grep -Fq -- 'must not run Git commands' "$ROOT/commands/write-doc.md"
grep -Fq -- 'suggested commit message' "$ROOT/commands/write-doc.md"
grep -Fq -- 'git add -A' "$ROOT/commands/ammend-push.md"
grep -Fq -- 'git commit --amend' "$ROOT/commands/ammend-push.md"
grep -Fq -- 'Co-authored-by' "$ROOT/commands/ammend-push.md"
grep -Fq -- 'git push' "$ROOT/commands/ammend-push.md"
grep -Fq -- '--force-with-lease' "$ROOT/commands/ammend-push.md"
grep -Fq -- '`Description`' "$ROOT/commands/suggest-mr-description.md"
grep -Fq -- '`Context`' "$ROOT/commands/suggest-mr-description.md"
grep -Fq -- '`How to test the code`' "$ROOT/commands/suggest-mr-description.md"
grep -Fq -- '`--apply`' "$ROOT/commands/suggest-mr-description.md"
grep -Fq -- '`concise`' "$ROOT/commands/suggest-mr-description.md"
grep -Fq -- 'more direct and compact' "$ROOT/commands/suggest-mr-description.md"
grep -Fq -- 'must not change the MR/PR' "$ROOT/commands/suggest-mr-description.md"
grep -Fq -- 'gh pr edit --body-file' "$ROOT/commands/suggest-mr-description.md"
grep -Fq -- 'glab mr update --description' "$ROOT/commands/suggest-mr-description.md"

HOME="$HOME_DIR" XDG_CONFIG_HOME="$XDG_DIR" \
    "$ROOT/Scripts/install.sh" opencode claude codex
HOME="$HOME_DIR" XDG_CONFIG_HOME="$XDG_DIR" \
    "$ROOT/Scripts/install.sh" opencode claude codex

for installed_dir in \
    "$XDG_DIR/opencode/commands" \
    "$HOME_DIR/.claude/commands" \
    "$HOME_DIR/.codex/prompts"; do
    for name in ammend-push link-docs read-docs suggest-mr-description write-doc; do
        cmp -s -- "$ROOT/commands/$name.md" "$installed_dir/$name.md"
    done
done

HOME="$HOME_DIR" XDG_CONFIG_HOME="$XDG_DIR" \
    "$ROOT/Scripts/uninstall.sh" opencode claude codex

for installed_dir in \
    "$XDG_DIR/opencode/commands" \
    "$HOME_DIR/.claude/commands" \
    "$HOME_DIR/.codex/prompts"; do
    for name in ammend-push link-docs read-docs suggest-mr-description write-doc; do
        test ! -e "$installed_dir/$name.md"
    done
done

mkdir -p -- "$XDG_DIR/opencode/commands"
printf '%s\n' 'user-owned command' > "$XDG_DIR/opencode/commands/link-docs.md"
if HOME="$HOME_DIR" XDG_CONFIG_HOME="$XDG_DIR" \
    "$ROOT/Scripts/install.sh" opencode; then
    printf 'Installer unexpectedly replaced an unmanaged command.\n' >&2
    exit 1
fi
grep -Fxq -- 'user-owned command' "$XDG_DIR/opencode/commands/link-docs.md"

REPOSITORY="$TEMP_ROOT/repository"
WORKTREE="$TEMP_ROOT/worktree"
VAULT="$TEMP_ROOT/vault"
mkdir -p -- "$REPOSITORY" "$VAULT"
git -C "$REPOSITORY" init -q
git -C "$REPOSITORY" config user.name 'Agent Docs Test'
git -C "$REPOSITORY" config user.email 'agent-docs@example.invalid'
git -C "$REPOSITORY" commit --allow-empty -q -m initial
git -C "$REPOSITORY" worktree add -q -b test-worktree "$WORKTREE"
git -C "$REPOSITORY" config --local agentDocs.path "$VAULT"

test "$(git -C "$WORKTREE" config --local --get agentDocs.path)" = "$VAULT"
test ! -e "$REPOSITORY/.git/config.worktree"

printf 'All tests passed.\n'
