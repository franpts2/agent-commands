---
description: Capture the current work as a new Markdown note in the linked documentation vault.
---

<!-- agent-docs-commands:managed -->

Create one concise documentation note based on the current conversation and
repository state.

The raw command arguments are:

<arguments>
$ARGUMENTS
</arguments>

Follow these rules:

1. Confirm the current directory is inside a Git worktree. Load the configured
   root with `git config --local --get agentDocs.path`. If no value exists,
   stop and tell the user to run `/link-docs <vault-path>` first.
2. Resolve the configured root to an absolute physical path and verify that it
   is an existing writable directory. Never write outside that root or follow
   a symlink that leaves it.
3. Parse an optional first word as the kind when it is one of `note`,
   `research`, `brainstorm`, `explanation`, `decision`, `implementation`, or
   `handoff`. Otherwise use `note` and treat all arguments as the title. If no
   title remains, derive a short, specific title from the current conversation.
4. Collect repository metadata when available: repository name, repository
   root, current worktree name, branch, and 12-character commit ID. Metadata
   collection must not modify the repository.
5. The only permitted destination is `<configured-root>/_Agent Inbox`. Refuse
   to continue if the inbox path exists as a symlink or as a non-directory. If
   absent, ask for confirmation and create that one directory only.
6. Build a filename as `YYYY-MM-DD-<lowercase-ascii-slug>.md`. Keep the slug
   under 80 characters. If the path already exists, add `-2`, `-3`, and so on.
   Never overwrite, append to, rename, or delete an existing file.
7. Draft useful Markdown rather than a raw transcript. Include YAML frontmatter
   with safely quoted `title`, `kind`, `status: draft`, ISO-8601 `created`,
   `project`, `worktree`, `branch`, and `commit` values. Omit unavailable
   fields rather than inventing them. `reviewed` is reserved for notes a person
   has revised and approved; never assign it when creating a note.
8. Structure the body for the selected kind:
   - `research`: context, findings, evidence, implications, open questions.
   - `brainstorm`: goal, ideas, tradeoffs, promising directions, next steps.
   - `explanation`: topic overview, key concepts, how it works, concrete
     examples, caveats and common misconceptions, related topics.
   - `decision`: context, decision, rationale, consequences, follow-ups.
   - `implementation`: objective, current state, requirements and non-goals,
     iterative implementation steps, verification, risks and open questions,
     Git constraints, and a suggested commit message. Write this as an
     execution-ready plan for another agent. Each ordered iteration must name
     the relevant files or symbols when known, the exact changes to make, the
     expected outcome, and focused checks to run before continuing. Instruct
     the agent to inspect the result of each iteration, resolve failures, and
     update the remaining steps when repository discoveries invalidate an
     assumption. Require the agent to stop after every iteration, report the
     changes and check results, and wait for explicit user approval before
     starting the next iteration. The original request or approval of the plan
     does not count as approval to continue between iterations. State
     explicitly that the agent must not run Git commands or perform Git
     operations, including staging, committing, amending, rebasing, merging,
     pushing, or creating or switching branches, unless the user explicitly
     requests them. The suggested commit message is text only and does not
     authorize a commit.
   - `handoff`: objective, completed work, current state, blockers, next steps.
   - `note`: context, notes, next steps.
9. Include source file and line references when claims came from repository
   code. Exclude secrets, credentials, token-like values, private environment
   values, unrelated personal data, and hidden chain-of-thought. Summarize
   reasoning and outcomes instead.
10. Show the destination and a short content outline, then ask for confirmation
    immediately before writing. Use a file-writing tool rather than a shell
    heredoc. After writing, verify that the new file exists under the inbox and
    report its vault-relative path.
