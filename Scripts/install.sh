#!/bin/sh

set -eu

MARKER='agent-docs-commands:managed'
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
COMMANDS_DIR="$ROOT/commands"

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

result=0
for target in "$@"; do
    if ! destination_dir=$(target_directory "$target"); then
        usage
        exit 64
    fi

    mkdir -p -- "$destination_dir"
    for source_file in "$COMMANDS_DIR"/*.md; do
        destination_file="$destination_dir/$(basename -- "$source_file")"

        if [ -L "$destination_file" ]; then
            printf 'Refusing to replace symlink: %s\n' "$destination_file" >&2
            result=1
            continue
        fi

        if [ -e "$destination_file" ] && ! grep -Fq -- "$MARKER" "$destination_file"; then
            printf 'Refusing to replace unmanaged file: %s\n' "$destination_file" >&2
            result=1
            continue
        fi

        install -m 0644 "$source_file" "$destination_file"
        printf 'Installed %s command: %s\n' "$target" "$destination_file"
    done
done

exit "$result"
