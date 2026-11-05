# Contributing

Thanks for improving Agent Docs Commands.

## Requirements

- A POSIX `sh` and Git.
- At least one supported agent, OpenCode, Claude Code, or Codex, for manual
  testing.
- No third-party dependencies. Do not add a package manager, build step, or
  runtime dependency for the prompts or shell scripts.

## Development

1. Fork and clone the repository.
2. Create a topic branch.
3. Make the change and update the tests and documentation that describe it.
4. Run `./Scripts/test.sh`.
5. Open a pull request using the template.

## Changing a command

- Keep one command per file in `commands/<name>.md`. The file name is the
  command name that users type.
- Keep the YAML front matter with a short `description`.
- Keep the `<!-- agent-docs-commands:managed -->` marker. The installer and
  uninstaller depend on it to avoid touching user-owned files.
- Keep an `<arguments>` block containing `$ARGUMENTS` so every supported agent
  receives the raw arguments.
- Update the README command table, behavior section, and examples.
- Add the file name to the command lists in `Scripts/test.sh` and
  `Scripts/uninstall.sh`.
- Add `grep` assertions to `Scripts/test.sh` for safety-critical instructions.
- Keep prompts platform-neutral. Do not assume a hosting provider or CLI unless
  the command explicitly requires it.
- Do not weaken rules that prevent overwriting files, bypassing hooks, silently
  pushing, or silently updating remote state.
- Do not include credentials, tokens, personal paths, customer data, or raw chat
  transcripts in prompts, tests, or examples.

Renaming a command is a compatibility change. Update the README, tests, and
uninstaller in the same pull request and call it out in the description.

## Style

- Shell scripts use POSIX `sh`, `set -eu`, quoted variables, and no bashisms.
- Markdown wraps near 80 columns and uses the present tense.
- Explain behavior and its limits rather than promising guarantees.
- Commit messages use a short conventional subject, one coherent change per
  commit, and no co-author trailer. This matches the project's `/make-commits`
  behavior.

## Pull requests

- Explain what changed and why.
- List the commands and agents you tested manually.
- Confirm `./Scripts/test.sh` passes locally and CI is green.
- Call out compatibility changes, especially renamed or removed commands.

## Security

Do not report vulnerabilities in a public issue. See [SECURITY.md](SECURITY.md).

## License

By contributing, you agree that your contributions are licensed under the
[MIT License](LICENSE).
