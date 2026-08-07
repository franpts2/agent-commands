---
description: Link this repository and all of its worktrees to an Obsidian vault.
---

<!-- agent-docs-commands:managed -->

Link the current Git repository to a local documentation directory.

The raw command arguments are:

<arguments>
$ARGUMENTS
</arguments>

Follow these rules:

1. Confirm the current directory is inside a Git worktree. If it is not, stop
   with a clear explanation.
2. Treat the complete argument value as the directory path. If it is empty,
   ask the user for the path and do nothing else.
3. Expand a leading `~`, resolve the path to an absolute physical path, and
   verify that it is an existing readable directory. Reject values containing
   newlines or control characters. Do not create the directory.
4. Show the resolved path and ask for confirmation before changing Git config.
5. Store the path with `git config --local agentDocs.path <resolved-path>`.
   Quote the path as one shell argument; never use `eval` or interpolate it
   into a compound shell command.
6. Read the value back with `git config --local --get agentDocs.path` and
   verify that it exactly matches the resolved path.
7. Report that the mapping is local to this clone and shared by its linked
   worktrees. Do not read or write any vault content.
