#!/bin/sh

set -eu

MARKER='agent-docs-commands:managed'

usage() {
    printf 'Usage: %s [opencode] [claude] [codex]\n' "$0" >&2
}

target_directory() {
    case "$1" in
        opencode)
            printf '%s\n' "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/commands"
            ;;
        claude)
            printf '%s\n' "$HOME/.claude/commands"
            ;;
        codex)
            printf '%s\n' "$HOME/.codex/prompts"
            ;;
        *)
            return 1
            ;;
    esac
}

if [ "$#" -eq 0 ]; then
    set -- opencode
fi

for target in "$@"; do
    if ! destination_dir=$(target_directory "$target"); then
        usage
        exit 64
    fi

    for name in ammend-push link-docs make-commits prune-tests read-docs suggest-mr-description thermo-nuclear-code-quality-review write-doc; do
        destination_file="$destination_dir/$name.md"
        if [ -f "$destination_file" ] && [ ! -L "$destination_file" ] && \
            grep -Fq -- "$MARKER" "$destination_file"; then
            rm -- "$destination_file"
            printf 'Removed %s command: %s\n' "$target" "$destination_file"
        fi
    done
done
