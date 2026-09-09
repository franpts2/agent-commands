---
description: Remove unnecessary or redundant tests from the current feature without weakening meaningful coverage.
---

<!-- agent-docs-commands:managed -->

Review and prune tests created or changed for the current feature.

The raw command arguments are optional feature scope or additional constraints:

<arguments>
$ARGUMENTS
</arguments>

Follow these rules:

1. Determine the feature scope from the arguments, current conversation,
   repository state, and relevant diff. If the scope remains ambiguous, ask
   the user one concise question before editing.
2. Inspect the feature implementation and its added or modified tests. By
   default, do not remove or rewrite unchanged pre-existing tests outside the
   feature scope.
3. Identify tests that add no meaningful confidence, such as exact duplicates,
   scenarios already covered by a stronger test through the same code path,
   tautological assertions, or tests of incidental implementation details that
   do not protect observable behavior.
4. Preserve tests that cover a distinct requirement, public contract,
   regression, branch, boundary condition, error path, security property, or
   meaningful integration. Do not remove tests merely to reduce test count,
   execution time, or maintenance work.
5. Remove only tests whose redundancy or lack of value can be demonstrated
   from the implementation and remaining test coverage. If a questionable test
   might protect behavior that is not clearly documented or covered elsewhere,
   keep it and report the uncertainty rather than guessing.
6. Keep the smallest coherent set of tests that fully covers the feature's
   intended behavior. Simplify duplicated setup only when needed to support the
   pruning; do not perform unrelated test or production-code refactors.
7. Run the narrowest relevant test command after editing. If practical, verify
   that the removed tests would not leave their distinct code paths or
   requirements uncovered. Resolve failures caused by the edits, but do not
   change intended production behavior to make the remaining tests pass.
8. Report which tests were removed or consolidated, why each was unnecessary,
   what meaningful coverage remains, and the verification command and result.
   If no tests are safely removable, make no changes and say so explicitly.
