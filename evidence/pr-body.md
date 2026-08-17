# Draft PR: Java 17 Orders/Billing Seam with Evidence Gates

## Summary
Modernizes the Orders/Billing monolith from Java 8 to Java 17 with a minimal, scoped change that introduces a module seam via `BillingClient`.

## Changes
- **pom.xml**: Updated `maven.compiler.source/target` from 1.8 to 17
- **BillingClient.java**: New interface defining the billing contract
- **OrdersService.java**: Refactored to depend on `BillingClient` interface instead of `BillingService` directly

## Evidence

### Compile & Test (Gate 1)
All tests pass — see [evidence/build-and-test.log](../evidence/build-and-test.log)

### Dependency Inventory (Gate 2)
No new runtime dependencies — see [evidence/dependency-tree.log](../evidence/dependency-tree.log)

### Diff Allowlist (Gate 3)
Changes limited to:
- `pom.xml`
- `src/main/java/com/demo/billing/BillingClient.java`
- `src/main/java/com/demo/orders/OrdersService.java`

See [evidence/diff-files.log](../evidence/diff-files.log)

### SCA (Gate 4)
No vulnerabilities — see [evidence/sca-report.md](../evidence/sca-report.md)

### Container/SBOM (Gate 5)
SBOM generated via Docker Buildx — see `out/` directory

## Status
**DRAFT** — This PR is held for human review. No merge or deployment is approved.

## Reviewer Questions
1. Is the BillingClient interface sufficient as a seam, or should it be in a separate module?
2. Are there other call sites to BillingService that need migration?
3. Should we add integration tests beyond the contract test?
