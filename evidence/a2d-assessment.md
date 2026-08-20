# A2D Modernization Assessment — orders-billing-monolith

**Date:** 2026-08-20  
**Change Request:** CRQ-10452  
**Agent:** A2D Modernization Agent  

---

## 1. INTAKE — Repository Scan

| Dimension | Finding | Risk |
|---|---|---|
| Build System | Maven 3.x with Maven Wrapper | LOW |
| Runtime | Java 1.8 (EOL March 2022) | CRITICAL |
| Source Files | 3 production classes | LOW |
| Test Files | 1 test class, 4 tests | MEDIUM |
| Runtime Dependencies | 0 | LOW |
| Test Dependencies | junit:4.13.2 → hamcrest-core:1.3 | LOW |
| Coupling | `new BillingService()` in OrdersService — tight coupling | HIGH |
| Dockerfile | Not present | HIGH |
| Injection / Interfaces | None | HIGH |

### Dependency Tree
```
com.demo:orders-billing-monolith:jar:1.0.0-SNAPSHOT
└── junit:junit:jar:4.13.2:test
    └── org.hamcrest:hamcrest-core:jar:1.3:test
```

### Coupling Evidence
- `OrdersService.java` line 11: `private final BillingService billingService = new BillingService();`
- Direct instantiation — no interface, no injection.

---

## 2. READINESS — Modernization Score

| Dimension | Score | Rationale |
|---|---|---|
| Dependency Health | 90% | Zero runtime deps, test deps current |
| Security Findings | 30% | Java 8 EOL — critical security risk |
| Test Coverage | 60% | 4 tests covering core paths |
| Runtime Support | 20% | Java 8 EOL since 2022 |
| Coupling Complexity | 30% | Direct instantiation, no interfaces, no DI |

**Overall: 46% — PROCEED WITH CAUTION**

---

## 3. GOVERNANCE — Compliance Check

| Check | Result |
|---|---|
| Approved libraries | PASS — junit, hamcrest-core on approved list |
| Shadow IT | PASS — none detected |
| Dependabot CVEs | N/A — alerts disabled on repo |
| EOL Runtime | FAIL — Java 8 is EOL |

**Overall: FAIL — EOL runtime requires remediation**

---

## 4. PROPOSED CHANGES

### Allowlisted Files

| # | File | Action | Change |
|---|---|---|---|
| 1 | pom.xml | MODIFY | Java 1.8 → 17 |
| 2 | src/main/java/com/demo/billing/BillingClient.java | CREATE | Interface seam |
| 3 | src/main/java/com/demo/billing/BillingService.java | MODIFY | Implements BillingClient |
| 4 | src/main/java/com/demo/orders/OrdersService.java | MODIFY | Constructor injection |
| 5 | src/main/java/com/demo/Main.java | MODIFY | Wire BillingService into OrdersService |
| 6 | src/test/java/com/demo/orders/OrdersBillingContractTest.java | MODIFY | Pass BillingService to constructor |
| 7 | Dockerfile | CREATE | Multi-stage build, eclipse-temurin:17-jre-alpine |

### What Does NOT Change
- Zero new runtime dependencies
- Zero business logic changes
- BillingService.charge() behavior identical

### Risks / Hypotheses Requiring Human Verification
1. Java 17 upgrade is compatible — no Java 8-specific APIs used (FACT: confirmed by source scan)
2. No CI/CD pipelines reference Java 8 explicitly (HYPOTHESIS)
3. eclipse-temurin:17-jre-alpine is available and approved in HP registry (HYPOTHESIS)

---

**STATUS: WAITING FOR HUMAN APPROVAL TO PROCEED**
