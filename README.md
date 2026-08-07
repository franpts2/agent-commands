# Agent Docs Commands

[![Test](https://github.com/franpts2/agent-docs-commands/actions/workflows/test.yml/badge.svg)](https://github.com/franpts2/agent-docs-commands/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Small, prompt-only commands for connecting a Git repository to an Obsidian
vault. There is no MCP server, daemon, package dependency, or network service.

## Commands

| Command | Purpose |
| --- | --- |
| `/link-docs <vault-path>` | Save the vault path in the repository's local Git config. |
| `/read-docs [topic]` | Find and read relevant Markdown notes without modifying the vault. |
| `/write-doc [kind] [title]` | Create a new note under `_Agent Inbox`. |

The mapping is stored as `agentDocs.path` in the repository's common Git
config. It is private to the local clone, is not committed, and is shared by
all linked worktrees of that clone.

## Install

OpenCode is the default target:

```sh
./Scripts/install.sh
```

Install for one or more supported agents:

```sh
./Scripts/install.sh opencode claude codex
```

Installed locations:

| Agent | Directory | Invocation |
| --- | --- | --- |
| OpenCode | `~/.config/opencode/commands` | `/link-docs` |
| Claude Code | `~/.claude/commands` | `/link-docs` |
| Codex | `~/.codex/prompts` | `/prompts:link-docs` |

Restart the agent after installation so it reloads the command files.

Then, from any worktree of a repository:

```text
/link-docs /absolute/path/to/Obsidian Vault
/read-docs authentication decisions
/write-doc research authentication findings
```

The agent may ask for permission to access the vault because it is outside the
active repository. Grant access only when the displayed path is the vault you
expect.

## Write Behavior

`/write-doc` creates Markdown files only in `<vault>/_Agent Inbox`. It refuses
to overwrite an existing note or write through a symlink. Notes include the
current repository, branch, worktree, and commit metadata when available.

Supported kinds are `note`, `research`, `brainstorm`, `decision`, and
`handoff`. If no kind is supplied, the command uses `note`. If no title is
supplied, the agent derives a concise title from the current conversation.

New notes use `status: draft`. After a person revises and approves a note, they
can change it to `status: reviewed`. `/read-docs` prioritizes reviewed notes as
higher-authority documentation while still checking whether their claims are
current and consistent with other sources.

## Privacy And Safety

- `/read-docs` reads Markdown only and treats note content as reference data,
  not as instructions to execute.
- `/write-doc` excludes credentials, tokens, environment values, and raw chat
  transcripts.
- No command makes network requests.
- The vault path remains in `.git/config` for the local clone.
- Existing files and unmanaged command definitions are never replaced.

## Uninstall

```sh
./Scripts/uninstall.sh opencode claude codex
```

With no arguments, the uninstaller targets OpenCode only. It removes only
files carrying this project's ownership marker.

## Development

Run the self-contained test suite:

```sh
./Scripts/test.sh
```

Tests use temporary home, repository, worktree, and vault directories and do
not modify live agent configuration.

## License

[MIT](LICENSE)
