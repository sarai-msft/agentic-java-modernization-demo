# Agentic Java Modernization Demo

Demonstrates agent-assisted Java 8 → Java 17 modernization with evidence gates.

## Story

`OrdersService` directly calls `BillingService`. The modernization patch:
1. Updates Maven compiler target from Java 8 to Java 17
2. Introduces a `BillingClient` interface as a module seam
3. Refactors `OrdersService` to depend on the interface

## Branches

- `main` — Java 8 baseline with direct Orders → Billing coupling
- `modernization/java17-billing-seam` — Scoped patch with Java 17 target and BillingClient seam

## Running

```bash
# Inspect the repository
bash scripts/inspect.sh

# Run validation gates (from modernization branch)
bash scripts/run-gates.sh

# Build container with SBOM (requires Docker Buildx)
bash scripts/build-image.sh
```

## Evidence

All validation evidence is collected in the `evidence/` folder:
- `build-and-test.log` — Maven compile and test output
- `dependency-tree.log` — Full dependency inventory
- `diff-files.log` — Changed files allowlist
- `sca-report.md` — Security composition analysis
- `pr-body.md` — Draft pull request body
- `trace.md` — Decision trace
