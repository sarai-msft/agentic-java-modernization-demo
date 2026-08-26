# A2D AI Decision Package

**Change request:** CRQ-10452  
**Prepared:** 2026-08-26  
**Repository:** `sarai-msft/agentic-java-modernization-demo`  
**Branch:** `modernize/java17-billing-seam-20260826`  
**Implementation commit:** `523a2d6`  
**Draft PR:** [#7 - CRQ-10452: Modernize Java 17 + BillingClient seam](https://github.com/sarai-msft/agentic-java-modernization-demo/pull/7)  
**Status:** WAITING FOR HUMAN APPROVAL

## Decision Summary

The allowlisted modernization upgraded the build target from Java 8 to Java 17, introduced a `BillingClient` interface at the order-to-billing boundary, changed `OrdersService` to constructor injection while retaining its no-argument constructor, and added a multi-stage container build using approved Eclipse Temurin 17 images. No business rules or runtime dependencies changed.

## Architecture Summary

### Before

```text
Main -> OrdersService -> new BillingService() -> billing logic
```

### After

```text
Main -> OrdersService -> BillingClient <- BillingService
                              |
                         constructor injection
```

| Property | Before | After |
|---|---|---|
| Java target | 8 | 17 |
| Billing boundary | Concrete `BillingService` | `BillingClient` interface |
| Dependency construction | Field initialization | Constructor injection with compatible default constructor |
| Runtime dependencies | 0 | 0 |
| Container image | None | `eclipse-temurin:17-jre-alpine` runtime |
| Business logic | Baseline | Unchanged |

## Security Findings

### Facts

| Finding | Result | Evidence |
|---|---|---|
| EOL Java 8 build target | REMEDIATED | Maven compiler release is now 17 |
| Runtime dependency exposure | PASS | Post-change dependency tree contains no runtime dependencies |
| Approved libraries | PASS | JUnit and Hamcrest Core are approved and test-only |
| Approved base image | PASS | Runtime uses `eclipse-temurin:17-jre-alpine` |
| Dependency updates | PASS | Maven reports no newer dependency versions |
| Dependabot alerts | FAIL | GitHub API returned HTTP 403 because alerts are disabled |

### Residual Risk

Known-CVE status cannot be independently confirmed through the required GitHub Dependabot gate until alerts are enabled. Human approval requires either enabling Dependabot alerts and reviewing the result or accepting a documented governance exception.

## Validation Results

| Gate | Result | Evidence |
|---|---|---|
| Focused billing contract | PASS | 5 tests; 0 failures; 0 errors; 0 skipped |
| Clean Maven verification | PASS | `clean verify`; Java release 17 |
| Post-change dependency tree | PASS | JUnit 4.13.2 and Hamcrest Core 1.3 remain test-only |
| Dependency update scan | PASS | No newer dependency versions reported |
| Diff whitespace check | PASS | No errors |
| Change allowlist | PASS | No changed paths outside the approved scope |
| Docker image build | PASS | `orders-service:latest`; manifest `sha256:da2e9b234468bb690e89de4e7368488a25cd17f08862e5d507238c61e0ef7ee3` |
| Named container run | PASS | `orders-demo` exited 0 and printed expected order-processing output |

## Governance Result

| Control | Result |
|---|---|
| Approved dependency registry | PASS |
| Shadow IT scan | PASS |
| Approved container base | PASS |
| Required Dependabot security-alert query | FAIL - alerts disabled |
| **Overall governance** | **FAIL pending remediation or approved exception** |

## Changed-File Allowlist

| File | Purpose |
|---|---|
| `pom.xml` | Java 17 compiler target |
| `Dockerfile` | Approved Java 17 build and runtime image |
| `src/main/java/com/demo/billing/BillingClient.java` | Billing interface contract |
| `src/main/java/com/demo/billing/BillingService.java` | Interface implementation |
| `src/main/java/com/demo/orders/OrdersService.java` | Constructor-injected billing dependency |
| `src/test/java/com/demo/orders/OrdersBillingContractTest.java` | Injected-client contract test |
| `evidence/a2d-assessment.md` | Pre-change assessment evidence |
| `evidence/approval-package.md` | Post-change decision evidence |

## Human Decision Required

Review draft PR [#7](https://github.com/sarai-msft/agentic-java-modernization-demo/pull/7), verify the stated absence of business-logic changes, and resolve the Dependabot governance failure through enablement or an approved exception.

**FINAL STATUS: WAITING FOR HUMAN APPROVAL**

This package does not authorize merge or deployment.