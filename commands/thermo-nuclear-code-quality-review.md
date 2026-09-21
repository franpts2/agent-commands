---
description: Run an unusually strict, project-aware maintainability review of the current changes.
---

<!-- agent-docs-commands:managed -->

Run a thermo-nuclear code quality review. This is a read-only review: do not
edit files, create commits, or update remote state.

The raw command arguments are an optional comparison target, review scope, or
additional constraints:

<arguments>
$ARGUMENTS
</arguments>

Follow these rules:

1. Parse an exact `--target <revision>` pair, when present, as the VCS revision
   or ref to compare against. Treat all remaining arguments as scope or review
   constraints, such as a path or feature name. Reject a missing, repeated, or
   option-like target instead of guessing. Never pass argument text through
   `eval` or interpolate it into a shell command string.
2. Before running any VCS command, inspect the current directory and its
   parents for a `.jj` directory. If one exists, use `jj` exclusively for
   status, history, diff, and changed-file discovery, even when the repository
   is colocated with Git. Otherwise, confirm that the directory belongs to a
   Git worktree and use `git` exclusively. If neither VCS is available, stop
   with a concise explanation.
3. Determine the comparison context without making network requests:
   - With `--target`, verify that the revision exists locally and compare the
     working copy/current branch with its merge base or nearest equivalent
     against that revision. Honor a clearly requested direct comparison.
   - Without `--target`, infer the local default or trunk branch from VCS
     metadata and compare the current branch with the appropriate merge base.
     Do not assume `main`, `master`, `staging`, or a remote name unless that ref
     exists. If no reliable base can be found, review staged, unstaged, and
     working-copy changes and disclose the narrower scope.
   - Include committed branch changes and all relevant local changes. Include
     untracked source files in the review even when the VCS diff omits them.
4. Gather status, revision/branch context, the complete relevant diff, and the
   changed-file list. Do not review commit titles alone. Respect a user-supplied
   scope, but inspect enough adjacent code to understand boundaries and avoid
   false findings. Exclude unrelated pre-existing work from findings.
5. Learn the project before judging it. Read applicable agent instructions,
   contribution guidance, architecture documentation, manifests, formatter and
   linter configuration, and representative neighboring code. Infer the
   language, framework, generated/vendor boundaries, layering, naming, and
   established local patterns. Repository-specific guidance takes precedence
   over generic preferences unless it creates a concrete maintainability risk.
6. Read the full contents of every meaningful changed source, test,
   configuration, schema, and migration file in scope. Also read callers,
   callees, types, tests, and canonical implementations needed to validate a
   potential finding. Skip binary, generated, vendored, lock, snapshot, and
   minified files unless the change itself makes them relevant. For an
   impractically large file, inspect all changed regions plus enough structure
   to understand the whole file and disclose that limitation.
7. Review with an unusually strict maintainability lens:
   - structural simplification and unnecessary indirection
   - abstractions that leak, duplicate behavior, or have the wrong ownership
   - file and function growth that mixes responsibilities
   - nested, duplicated, or state-dependent condition growth
   - opportunities to replace bespoke code with existing project, language,
     framework, or standard-library primitives
   - weak types, stringly typed data, unchecked conversions, and unclear
     validation or serialization boundaries
   - business rules or state owned outside the canonical layer
   - parallel sources of truth, dependency cycles, temporal coupling, and
     hidden mutation
   - tests that lock in incidental implementation while missing contracts
8. Be severe but evidence-based. Report only issues introduced or materially
   worsened by the reviewed changes. Do not invent project requirements, demand
   abstractions for one-off code, mistake unfamiliar style for bad structure,
   or add cosmetic nits while structural issues exist. Verify every finding
   against the full file and relevant surrounding code.
9. Order findings by severity: `Critical`, `High`, `Medium`, then `Low`. For
   every finding provide:
   - a concise title and precise file/line reference where possible
   - concrete evidence from the changed code
   - why the structure worsens maintenance, extension, or correctness
   - the cleaner structural direction, tied to this project's conventions
   - any uncertainty that could change the conclusion
10. Return findings first without softening their severity. Keep the summary
    short. If there are no findings, say so explicitly and state residual risks,
    files not fully inspected, and validation not performed. Do not pad the
    result with compliments or low-value observations.
