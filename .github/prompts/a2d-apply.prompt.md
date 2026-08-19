---
mode: agent
description: "A2D Apply + Validate + Approve — Execute after human approval"
tools:
  - run_in_terminal
  - read_file
  - create_file
  - replace_string_in_file
  - list_dir
  - grep_search
---

# A2D Apply Modernization

The human has approved the proposed changes. Now execute:

## Step 5: APPLY
1. Create a new git branch from main: `modernization/java17-billing-seam`
2. Apply the approved changes:
   - Upgrade pom.xml: maven.compiler.source/target/release from 8 → 17
   - Create BillingClient interface with the `charge()` method signature
   - Make BillingService implement BillingClient
   - Refactor OrdersService to accept BillingClient via constructor injection (keep default constructor using BillingService for backward compatibility)
3. Commit with message: "Modernize: Java 17 + BillingClient interface seam"
4. Show the diff summary (files changed, insertions, deletions)

## Step 6: VALIDATE
Run these gates and report PASS/FAIL for each:
1. **Compile & Test**: Run `mvnw.cmd clean test` — report test count and failures
2. **Dependency Inventory**: Run `mvnw.cmd dependency:tree` — confirm no new runtime deps
3. **Diff Allowlist**: Run `git diff --name-only main...HEAD` — confirm only allowlisted files changed (pom.xml + 3 java files)

## Step 7: APPROVE
Generate the AI Decision Package with:
- Application name
- Change summary
- Technical debt status (reduced/unchanged)
- Security findings (critical count)
- Test results (run/failures)
- Governance result (from prior assessment)
- Change Request number: CRQ-10452
- PR status: Ready (draft)

End with:

```
STATUS: WAITING FOR HUMAN APPROVAL
Change Request: CRQ-10452
Deployment: Blocked until approved
```

Save the decision package to `evidence/approval-package.md`.
