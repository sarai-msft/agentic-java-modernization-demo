# AI Decision Package — CRQ-10452

**Date:** 2026-08-20
**Change Request:** CRQ-10452
**Branch:** `modernize/java17-billing-seam`
**PR:** https://github.com/sarai-msft/agentic-java-modernization-demo/pull/2
**Agent:** A2D Modernization Agent (GitHub Copilot)

---

## Architecture Summary

**Before:** Java 8 monolith with `OrdersService` tightly coupled to `BillingService` via direct instantiation (`new BillingService()`). No interface abstractions, no Dockerfile.

**After:** Java 17 monolith with `OrdersService` depending on `BillingClient` interface via constructor injection. `BillingService` implements `BillingClient`. Dockerfile added with approved `eclipse-temurin:17-jre-alpine` base image.

**Business logic changes: NONE**

---

## Security Findings

| Finding | Severity | Resolution |
|---|---|---|
| Java 8 EOL runtime | CRITICAL | Upgraded to Java 17 (LTS, supported through 2029) |
| No known CVEs in dependencies | — | Only test-scoped dep: `junit:4.13.2` |

---

## Test Results

| Test | Result |
|---|---|
| `testPlaceOrderChargesBilling` | PASS |
| `testBillingServiceDirectly` | PASS |
| `testBillingRejectsZeroAmount` | PASS |
| `testBillingRejectsNullAmount` | PASS |

**4/4 tests passed. 0 failures. 0 errors.**

---

## Validation Gates

| Gate | Result |
|---|---|
| Compilation (Java 17) | PASS |
| Unit Tests (4/4) | PASS |
| App Execution | PASS |
| Docker Build (`orders-service`) | PASS |
| Docker Run (`orders-demo`) | PASS |
| Diff Allowlist (8 files) | PASS |
| New Runtime Dependencies | PASS (0 added) |
| Governance (approved registry) | PASS |
| Shadow IT Check | PASS (none found) |

---

## Files Changed

| File | Change |
|---|---|
| `pom.xml` | Java 8 → 17 compiler settings |
| `BillingClient.java` | NEW — interface seam |
| `BillingService.java` | Implements `BillingClient` |
| `OrdersService.java` | Constructor injection of `BillingClient` |
| `Main.java` | Wires `BillingService` into `OrdersService` |
| `OrdersBillingContractTest.java` | Uses constructor injection |
| `Dockerfile` | NEW — multi-stage build with `eclipse-temurin:17-jre-alpine` |
| `evidence/a2d-assessment.md` | Full A2D assessment report |

---

## Status: WAITING FOR HUMAN APPROVAL
