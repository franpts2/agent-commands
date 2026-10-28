---
description: Create incremental conventional commits for the changes made in this session.
---

<!-- agent-docs-commands:managed -->

Create one or more incremental conventional commits for the changes you made in
this session.

The raw command arguments are optional additional constraints:

<arguments>
$ARGUMENTS
</arguments>

Follow these rules:

1. Confirm the current directory is inside a Git worktree, `HEAD` names an
   existing commit, and a local branch is checked out. Refuse to continue
   during a merge, rebase, cherry-pick, or revert.
2. Identify the changes this session made. Use the conversation and the edits
   you performed as the source of truth, then cross-check `git status --short`,
   the unstaged diff, the staged diff, and untracked files. Commit only the
   paths and hunks you created, modified, or deleted yourself. If a change
   cannot be confidently attributed to this session, stop and ask the user one
   concise question. Never commit unrelated, pre-existing, or user-authored
   worktree changes, and never stage the whole worktree. If the index already
   contains staged changes from outside this session, stop and ask rather than
   committing or unstaging them. Stop and ask before committing likely secrets,
   credentials, private keys, or environment files.
3. Inspect recent commit history, such as `git log --oneline -50`, to learn the
   repository's conventional commit convention, and check contribution guidance
   when present. Use a scope only when the repository consistently uses scopes;
   omit the scope when it does not. Follow the existing type and scope
   vocabulary, including package, module, or area names. If the recent pattern
   is genuinely mixed, ask the user one concise question instead of guessing.
4. Group the session changes into the smallest number of commits that each
   represent one coherent, self-contained change. Do not bundle unrelated
   changes, and do not split one coherent change artificially. Order the
   commits so each builds on the previous one and the history stays coherent.
   Treat arguments as additional constraints on paths, types, scopes, or
   grouping; if an argument conflicts with these rules, stop and ask. Never
   create an empty commit. If there is nothing to commit, report that and stop.
5. Stage exactly what each commit needs with explicit `git add <path>`
   commands. When one file contains changes belonging to different commits,
   use `git add -p` or `git apply --cached` to stage only the relevant hunks.
   Never use `git add -A`, `git add .`, or `git commit -a`. Before each commit,
   inspect the staged diff and confirm it contains exactly that commit's change
   and nothing unrelated.
6. Write each message as a single conventional commit subject line only, in the
   form `<type>(<scope>): <subject>` or `<type>: <subject>`. Do not add a body,
   a longer description, bullet points, footers, `Co-authored-by`, or any other
   trailer. Use a concise imperative subject in lowercase after the colon,
   without a trailing period, and keep the full subject within about 72
   characters. Use types such as `build`, `chore`, `ci`, `docs`, `feat`, `fix`,
   `perf`, `refactor`, `revert`, `style`, and `test`. Add `!` only for a genuine
   breaking change, and use a scope only as determined in rule 3.
7. Create each commit with `git commit -m "<subject>"`. Never use `--amend`,
   `-a`, or `--no-verify`, and do not bypass, disable, or modify hooks. If a
   hook fails, fix the problem when it lies within the session changes;
   otherwise stop and report it. Do not rewrite, reorder, squash, or amend
   commits that already existed before this command.
8. Do not push, fetch, tag, or change remote state in any way. This command
   creates local commits only.
9. Verify with `git log` and `git status --short` that every session change is
   committed, nothing unrelated was committed, every message is a single
   subject line with no body or co-author trailer, and no unintended changes
   remain. Report each new commit hash and subject, plus any session change you
   intentionally left uncommitted.
