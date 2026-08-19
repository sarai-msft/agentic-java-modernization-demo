# A2D Modernization Assessment — orders-billing-monolith

**Date:** 2026-08-20
**Change Request:** CRQ-10452
**Agent:** A2D Modernization Agent (GitHub Copilot)

---

## 1. INTAKE — Repository Scan

### Build System & Runtime

| Dimension | Finding | Risk |
|---|---|---|
| Build System | Maven (with wrapper `mvnw`) | LOW |
| Runtime Version | **Java 8** (`maven.compiler.source=1.8`, `target=1.8`, `release=8`) | **CRITICAL** — Java 8 is EOL |
| Packaging | JAR (`orders-billing-monolith`) | LOW |
| Dockerfile | None present | MEDIUM — no containerization |

### Dependencies

| Dependency | Version | Scope | Status |
|---|---|---|---|
| `junit:junit` | 4.13.2 | test | Approved |

Runtime dependencies: 0

### Source Architecture

| Metric | Value |
|---|---|
| Source files | 3 (`Main.java`, `OrdersService.java`, `BillingService.java`) |
| Test files | 1 (`OrdersBillingContractTest.java`, 4 test methods) |
| Dockerfile | Missing |

### Coupling Analysis

| Location | Pattern | Risk |
|---|---|---|
| `OrdersService.java:11` | `new BillingService()` — direct instantiation | HIGH — tight coupling |
| `OrdersBillingContractTest.java:12` | `new OrdersService()` — no injection in tests | MEDIUM |

**FACT:** `OrdersService` directly instantiates `BillingService`. No interface exists. No constructor injection.

---

## 2. READINESS — Modernization Score

| Dimension | Score | Detail |
|---|---|---|
| Dependency Health | 100% | 0 runtime deps, 1 test dep (approved) |
| Security Findings | 20% | Java 8 is EOL — critical security risk |
| Test Coverage | 80% | 4 tests covering happy path + edge cases |
| Runtime Support | 20% | Java 8 — end of public updates |
| Coupling Complexity | 40% | Single tight-coupling point, small codebase |

**Overall Readiness: 52% — PROCEED WITH CAUTION**

---

## 3. GOVERNANCE — Approved Registry Check

| Component | Status |
|---|---|
| `junit:junit:4.13.2` (test) | APPROVED |
| `hamcrest-core` (transitive via junit) | APPROVED |
| Proposed base image: `eclipse-temurin:17-jre-alpine` | APPROVED |

Shadow IT findings: NONE

**Governance Result: PASS**

---

## 4. PROPOSED CHANGES

### File Allowlist

| # | File | Change | Impact |
|---|---|---|---|
| 1 | `pom.xml` | Update compiler source/target from 1.8 → 17, remove release property | LOW |
| 2 | `src/main/java/com/demo/billing/BillingClient.java` | NEW — Extract interface with `charge()` method | LOW |
| 3 | `src/main/java/com/demo/billing/BillingService.java` | Add `implements BillingClient` | LOW |
| 4 | `src/main/java/com/demo/orders/OrdersService.java` | Refactor to constructor injection using `BillingClient` | MEDIUM |
| 5 | `src/main/java/com/demo/Main.java` | Pass `new BillingService()` to `OrdersService` constructor | LOW |
| 6 | `src/test/java/com/demo/orders/OrdersBillingContractTest.java` | Update to pass `BillingService` via constructor | LOW |
| 7 | `Dockerfile` | NEW — Multi-stage build with `eclipse-temurin:17-jre-alpine` | LOW |

### Risks / Hypotheses

- **HYPOTHESIS:** No downstream systems depend on Java 8 bytecode version
- **HYPOTHESIS:** `eclipse-temurin:17-jre-alpine` is available in org container registry
- **HYPOTHESIS:** No CI/CD pipelines hardcode Java 8 toolchain paths
- **FACT:** Zero business logic changes — structural refactoring and runtime upgrade only

### New Runtime Dependencies Added: 0
