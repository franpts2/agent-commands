# Security Policy

## Scope

Agent Docs Commands installs Markdown prompt definitions for coding agents. It
has no server, daemon, network service, or runtime dependency. Security issues
in scope include:

- The installer or uninstaller overwriting files it does not own, following
  symlinks, or writing outside the documented target directories.
- A command definition that instructs an agent to exfiltrate data, bypass user
  approval, or take destructive actions beyond its documented behavior.
- A safety claim in the README or a command file that is incorrect.
- Secrets exposed by the test suite or the CI workflow.

Issues in the underlying agent, Git, GitHub CLI, or GitLab CLI are out of
scope. Report those to the respective project.

## Important limitation

The command files are prompt instructions, not an operating-system sandbox or a
security boundary. Whether an agent honors them depends on the agent and its
configuration. The secret-handling rules, such as stopping before committing
likely secrets, reduce risk but do not replace secret scanning, Git hooks, or
reviewing diffs before pushing.

Review agent actions and diffs before running `/amend-push` or
`/suggest-mr-description --apply`.

## Reporting a vulnerability

Do not open a public issue for a vulnerability. Use GitHub's private
vulnerability reporting:

https://github.com/franpts2/agent-docs-commands/security/advisories/new

Include the affected command or script, the agent and version, reproduction
steps, and impact. You can expect an initial response within 7 days. Confirmed
issues are fixed on `main` and credited unless you prefer otherwise.

## Supported versions

The latest commit on `main` is supported. This project does not maintain release
branches.
