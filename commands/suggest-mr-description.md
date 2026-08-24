---
description: Suggest a description for the current branch's merge request or pull request.
---

<!-- agent-docs-commands:managed -->

Draft a description for the merge request (MR) or pull request (PR) associated
with the current branch.

The raw command arguments are:

<arguments>
$ARGUMENTS
</arguments>

Follow these rules:

1. Parse `--apply` and `concise` only when each appears as an exact, standalone
   argument. `--apply` controls whether to update the MR/PR, while `concise`
   controls the writing style. Treat every other argument as additional context
   or a drafting constraint. Without `--apply`, this command is read-only and
   must not change the MR/PR.
2. Confirm the current directory is inside a Git worktree and that a local
   branch is checked out. Identify the MR/PR for that branch from its hosting
   provider. Prefer `glab` for GitLab and `gh` for GitHub. If there is no MR/PR,
   more than one candidate, no supported CLI, or no authenticated session, stop
   with a concise explanation rather than guessing.
3. Inspect the MR/PR title, existing body, base and head branches, commits,
   changed files, and complete diff. Read relevant repository code, tests,
   configuration, and contribution or MR/PR templates when needed. Do not infer
   the change solely from commit titles.
4. Write a concise, specific body with exactly these sections in this order:

   `Description`
   Describe what the change does and the problem it solves or feature it adds.

   `Context`
   Explain the rationale. Include relevant Jira tickets, other MR/PR links,
   wiki documentation, or chat threads only when they are available from the
   arguments, branch, commits, existing body, or repository. Never invent a
   reference.

   `How to test the code`
   Give concrete, reproducible test steps. Call out relevant feature gates,
   routes, subscriptions, entitlements, setup, and expected results when the
   code supports them. Clearly mark anything that still needs confirmation
   rather than fabricating details or claiming unobserved tests passed.
5. When `concise` is present, make every section more direct and compact. Use
   one short paragraph or at most three brief bullets per narrative section and
   only the minimum complete test steps. Remove repetition and secondary detail,
   but retain essential rationale, references, prerequisites, and expected
   results.
6. Preserve required checklist items, hidden markers, or other template content
   from the existing body after those three sections when present. Do not
   include commentary, analysis, or unsupported claims in the proposed body.
7. Without `--apply`, print the complete proposed body as plain text in the
   response and explicitly state that the MR/PR was not changed. Do not invoke
   `gh pr edit`, `glab mr update`, an API mutation, or any equivalent command.
8. With `--apply`, show the complete proposed body and ask for confirmation if
   material facts remain uncertain or applying it would discard existing
   non-template content. Otherwise, update only the current MR/PR body using
   `gh pr edit --body-file` on GitHub or `glab mr update --description` on
   GitLab. Pass the body without shell interpolation or `eval`, verify it by
   reading the MR/PR back, and report its URL. Do not change its title, labels,
   reviewers, state, or any other field.
