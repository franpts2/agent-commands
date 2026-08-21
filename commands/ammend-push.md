---
description: Stage all changes, amend HEAD without adding co-authors, and safely push it.
---

<!-- agent-docs-commands:managed -->

Stage the current repository changes, amend them into the current commit, and
push the amended commit.

The raw command arguments are optional additional constraints:

<arguments>
$ARGUMENTS
</arguments>

Follow these rules:

1. Confirm the current directory is inside a Git worktree, `HEAD` names an
   existing commit, and a local branch is checked out. Refuse to continue
   during a merge, rebase, cherry-pick, or revert.
2. Inspect `git status --short`, the unstaged diff, and the staged diff. Treat
   non-empty arguments as additional constraints on the operation. If an
   argument conflicts with these rules or leaves the intended changes
   ambiguous, stop and ask the user one concise question.
3. Require the current branch to have an upstream. If it does not, stop and ask
   the user to specify the remote and branch rather than guessing a push
   destination.
4. By default, include every current modification, deletion, and untracked file
   with `git add -A`. Before staging, stop and ask the user if the changes
   include likely secrets, credentials, private keys, environment files, or
   obviously unrelated work. Do not discard or rewrite any worktree changes.
5. Record the exact current commit message, then run `git commit --amend
   --no-edit`. Preserve the existing author and commit message. Do not add,
   append, generate, or suggest a `Co-authored-by` trailer or any other
   co-author attribution.
6. Verify that the amended commit message exactly matches the recorded message
   and that no new `Co-authored-by` trailer was introduced. If verification
   fails, do not push and clearly report the problem.
7. Push the checked-out branch to its configured upstream with `git push
   --force-with-lease`. Never use plain `--force`. If the lease is rejected,
   do not retry by weakening the protection; report that the remote changed.
8. Report the amended commit ID, the upstream ref, and whether the push
   succeeded. Do not add co-authors to the final report as commit trailers.
