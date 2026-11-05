# Agent Commands - Prompt Workflows for Coding Agents

[![Test](https://github.com/franpts2/agent-docs-commands/actions/workflows/test.yml/badge.svg)](https://github.com/franpts2/agent-docs-commands/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

<div align="left">
    <img src="https://img.shields.io/badge/OpenCode-111827?style=for-the-badge" alt="OpenCode"/>
    <img src="https://img.shields.io/badge/Claude_Code-D97757?style=for-the-badge&logo=anthropic&logoColor=white" alt="Claude Code"/>
    <img src="https://img.shields.io/badge/Codex-000000?style=for-the-badge&logo=openai&logoColor=white" alt="Codex"/>
    <img src="https://img.shields.io/badge/Shell-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" alt="Shell"/>
</div>

## About

Agent Docs Commands is a dependency-free collection of prompt commands for repository documentation and development workflows. It installs Markdown definitions for OpenCode, Claude Code, and Codex; there is no MCP server, daemon, package dependency, or network service.

The command files instruct the selected coding agent how to behave. Safety constraints inside prompts are not an operating-system sandbox and still depend on the agent honoring those instructions.

## Commands

| Command | Purpose |
| --- | --- |
| `/link-docs <vault-path>` | Save the vault path in the repository's local Git config. |
| `/read-docs [topic]` | Find and read relevant Markdown notes without modifying the vault. |
| `/write-doc [kind] [title]` | Create a new note under `_Agent Inbox`. |
| `/amend-push` | Stage all changes, amend the current commit without adding co-authors, and push safely. |
| `/make-commits [constraints]` | Create incremental conventional commits for this session's changes. |
| `/suggest-mr-description [concise] [--apply]` | Draft a description for the current branch's MR/PR, optionally applying it. |
| `/prune-tests [feature scope]` | Remove redundant or unnecessary tests from the current feature without weakening meaningful coverage. |
| `/thermo-nuclear-code-quality-review [--target <revision>] [scope]` | Run a strict, project-aware maintainability review of the current changes. |

The mapping is stored as `agentDocs.path` in the repository's common Git
config. It is private to the local clone, is not committed, and is shared by
all linked worktrees of that clone.

## Install

Requirements: Git, a POSIX shell, and at least one supported coding agent. `gh` or `glab` is required only when using `/suggest-mr-description` with a hosted pull or merge request. The scripts target POSIX `sh`; CI runs on Linux, and macOS and Windows through WSL or Git Bash use the same commands.

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

OpenCode honors `${XDG_CONFIG_HOME}/opencode/commands` when `XDG_CONFIG_HOME` is set.

Restart the agent after installation so it reloads the command files.

Then, from any worktree of a repository:

```text
/link-docs /absolute/path/to/Obsidian Vault
/read-docs authentication decisions
/write-doc research authentication findings
/amend-push
/make-commits
/make-commits src/auth
/suggest-mr-description
/suggest-mr-description concise
/suggest-mr-description --apply
/prune-tests
/prune-tests authentication refresh
/thermo-nuclear-code-quality-review
/thermo-nuclear-code-quality-review --target origin/staging
/thermo-nuclear-code-quality-review src/auth
```

The agent may ask for permission to access the vault because it is outside the
active repository. Grant access only when the displayed path is the vault you
expect.

## Write Behavior

`/write-doc` creates Markdown files only in `<vault>/_Agent Inbox`. It refuses
to overwrite an existing note or write through a symlink. Notes include the
current repository, branch, worktree, and commit metadata when available.

Supported kinds are `note`, `research`, `brainstorm`, `explanation`,
`decision`, `implementation`, and `handoff`. Use `explanation` to document a
clear explanation of a particular topic. If no kind is supplied, the command
uses `note`. If no title is supplied, the agent derives a concise title from
the current conversation.

An `implementation` note is an execution-ready feature plan for another agent.
It divides the work into verified iterations, identifies concrete files and
changes when known, and tells the agent to reassess later steps as it learns
from the repository. The agent must stop after every iteration and wait for
explicit user approval before continuing. The note also prohibits Git commands
and operations unless the user explicitly requests them. It includes a
suggested commit message for the user without authorizing the agent to commit.

New notes use `status: draft`. After a person revises and approves a note, they
can change it to `status: reviewed`. `/read-docs` prioritizes reviewed notes as
higher-authority documentation while still checking whether their claims are
current and consistent with other sources.

## Amend And Push Behavior

`/amend-push` stages all current changes with `git add -A`, amends `HEAD` while
preserving its author and message, and does not add `Co-authored-by` trailers.
It requires a configured upstream and pushes with `--force-with-lease`, never
plain `--force`.

## Commit Behavior

`/make-commits` creates incremental conventional commits for the changes the
agent made in the current session. It commits only paths and hunks attributable
to that session, stopping to ask when a change cannot be confidently attributed
or when the worktree contains likely secrets. Optional arguments can constrain
paths, types, scopes, or grouping.

Each commit contains one coherent change, and files can be split by hunk when
needed. Messages are a single conventional commit subject line such as
`feat(auth): add refresh token rotation` or `docs: update install steps`, with
no body, description, footers, or co-author trailer. The agent uses a scope only
when the repository's recent history uses scopes consistently, and otherwise
omits it. The command creates local commits only: it never pushes, fetches, tags,
amends existing commits, or bypasses Git hooks.

## MR/PR Description Behavior

`/suggest-mr-description` inspects the current branch's merge request or pull
request and drafts `Description`, `Context`, and `How to test the code`
sections. It returns the proposed body as plain text without changing the
MR/PR. Pass the explicit `--apply` argument to update the remote description.
Pass `concise` for shorter, more straightforward sections; it can be combined
with `--apply`. The command supports GitLab through `glab` and GitHub through
`gh`.

## Test Pruning Behavior

`/prune-tests` reviews tests added or modified for the current feature and
removes only those that demonstrably duplicate stronger coverage or protect no
meaningful observable behavior. It preserves distinct requirements,
regressions, branches, boundaries, error paths, security properties, and public
contracts. Pass an optional feature scope when the current conversation and
repository diff do not identify the feature clearly.

## Thermo-Nuclear Review Behavior

`/thermo-nuclear-code-quality-review` performs a read-only maintainability
review against an explicit `--target` revision or an inferred local default
branch. It checks for Jujutsu before Git, includes committed and local changes,
and learns each repository's guidance, tooling, architecture, and neighboring
patterns before reporting structural findings. Optional trailing arguments can
narrow the review to a path or feature.

## Privacy And Safety

- `/read-docs` reads Markdown only and treats note content as reference data,
  not as instructions to execute.
- `/write-doc` excludes credentials, tokens, environment values, and raw chat
  transcripts.
- The documentation commands make no network requests. `/amend-push` pushes
  the amended commit to the branch's configured Git upstream.
- `/make-commits` creates local commits only. It commits nothing outside the
  current session's changes and never pushes or changes remote state.
- `/suggest-mr-description` reads the current MR/PR from its hosting provider
  and changes its body only when passed `--apply`.
- `/prune-tests` limits edits to tests in the current feature scope by default
  and keeps uncertain or uniquely valuable coverage.
- `/thermo-nuclear-code-quality-review` is read-only and does not fetch, edit,
  commit, or update remote state.
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

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Run `./Scripts/test.sh` before opening a
pull request, and update the README, tests, and uninstaller when adding or
renaming a command.

## Security

The command files are prompt instructions, not an operating-system sandbox.
Read [SECURITY.md](SECURITY.md) before using commands that read outside the
repository or push changes, and report vulnerabilities privately rather than in
a public issue.

## Project Structure

```text
commands/                          Prompt command definitions
Scripts/install.sh                 Marker-aware multi-agent installer
Scripts/uninstall.sh               Managed command removal
Scripts/test.sh                    Prompt and installer verification
.github/workflows/test.yml         GitHub Actions test workflow
.github/ISSUE_TEMPLATE/            Issue forms
.github/pull_request_template.md   Pull request checklist
CONTRIBUTING.md                    Development and contribution guidance
SECURITY.md                        Security policy and reporting
```

## License

[MIT](LICENSE)
