# A2D Modernization Assessment — Orders Billing Monolith

**Date:** 2026-08-20
**Change Request:** CRQ-10452
**Status:** PENDING HUMAN APPROVAL

---

## Stage 1: INTAKE — Risk Assessment

| Dimension | Finding | Risk |
|---|---|---|
| Build system | Maven (pom.xml) | None |
| Java runtime | 1.8 / 8 (source, target, release) | **HIGH** — Java 8 EOL |
| Source files | 3 main + 1 test | Low |
| Test coverage | 4 @Test methods | Moderate |
| Dockerfile | Not present | **MEDIUM** — not cloud-ready |
| Runtime dependencies | 0 (junit:4.13.2 test-only) | None |
| Coupling | `new BillingService()` in OrdersService | **HIGH** — tight coupling |
| Interface seams | None | **HIGH** — no decoupling boundary |

---

## Stage 2: READINESS — Modernization Score

| Dimension | Score | Rationale |
|---|---|---|
| Dependency health | 100% | Zero runtime dependencies |
| Security findings | 40% | Java 8 EOL |
| Test coverage | 70% | 4 tests, happy path + edge cases |
| Runtime support | 40% | Java 8 EOL |
| Coupling complexity | 30% | Direct instantiation, no interfaces |

**Modernization Readiness Score: 56% — PROCEED WITH CAUTION**

---

## Stage 3: GOVERNANCE — Dependency & Image Audit

| Item | Type | Approved | Status |
|---|---|---|---|
| junit:4.13.2 | Test dependency | Yes | PASS |
| eclipse-temurin:17-jre-alpine | Base image (proposed) | Yes | PASS |

**Shadow IT: None detected**
**Governance Result: PASS**

---

## Stage 4: PROPOSED CHANGES

| # | File | Change | Impact |
|---|---|---|---|
| 1 | pom.xml | Upgrade compiler source/target/release 8 → 17 | Low |
| 2 | BillingClient.java | New interface: `charge(String, BigDecimal)` | Low |
| 3 | BillingService.java | Add `implements BillingClient` | Low |
| 4 | OrdersService.java | Constructor injection, field type → BillingClient | Medium |
| 5 | Dockerfile | New: multi-stage build, eclipse-temurin:17-jre-alpine | Low |

### Risks / Hypotheses
- **HYPOTHESIS**: Existing 4 tests pass without modification (high confidence)
- **HYPOTHESIS**: Main.java default constructor continues to work
- **FACT**: Zero new runtime dependencies
- **FACT**: Zero business logic changes

---

**AWAITING HUMAN APPROVAL TO PROCEED**
