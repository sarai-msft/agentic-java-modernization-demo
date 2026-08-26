# A2D Modernization Assessment

**Assessment date:** 2026-08-26  
**Repository:** `sarai-msft/agentic-java-modernization-demo`  
**Branch:** `main`  
**Decision status:** WAITING FOR HUMAN APPROVAL

## 1. Intake

### Facts

| Area | Finding | Risk |
|---|---|---|
| Build | Maven Wrapper 3.9.9; `clean verify` passes | Low |
| Runtime target | Maven source, target, and release are Java 8 | High: EOL runtime target |
| Assessment JDK | Microsoft OpenJDK 17.0.20 LTS | Low: upgrade toolchain is available |
| Dependencies | 0 runtime dependencies; JUnit 4.13.2 and transitive Hamcrest Core 1.3 are test-only | Low |
| Dependency updates | Maven Versions Plugin reports no newer dependency versions | Low |
| Coupling | `OrdersService` directly constructs `BillingService` | Medium: implementation cannot be substituted at the boundary |
| Tests | 1 test file containing 4 passing contract tests | Medium: core behavior is covered, but measured line/branch coverage is unavailable |
| Source size | 3 production Java files and 1 test Java file | Low |
| Containerization | No Dockerfile exists | Medium: runtime packaging is not standardized |
| Working tree | Clean on `main` at assessment time | Low |

### Dependency Graph

```text
com.demo:orders-billing-monolith:jar:1.0.0-SNAPSHOT
\- junit:junit:jar:4.13.2:test
   \- org.hamcrest:hamcrest-core:jar:1.3:test
```

## 2. Readiness

Scoring uses five equally weighted dimensions. Where objective coverage or security data is unavailable, the score is reduced rather than inferred.

| Dimension | Score | Evidence |
|---|---:|---|
| Dependency health | 100% | No runtime dependencies; no dependency updates reported |
| Security findings | 40% | Java 8 target is EOL; Dependabot findings cannot be queried because alerts are disabled |
| Test coverage | 60% | Four tests pass, but no coverage report is configured |
| Runtime support | 20% | Project targets Java 8; Java 17 LTS is available locally |
| Coupling complexity | 40% | Small codebase, but orders directly constructs the billing implementation |
| **Overall readiness** | **52%** | Equal-weight average |

**Progress:** `██████████░░░░░░░░░░ 52%`  
**Recommendation:** **PROCEED WITH CAUTION**

The change is small and has a green baseline, but the EOL runtime and unavailable Dependabot data require explicit governance attention.

## 3. Governance

### Approved Registry Check

| Component | Usage | Registry result |
|---|---|---|
| `junit:junit:4.13.2` | Test dependency | PASS: approved |
| `org.hamcrest:hamcrest-core:1.3` | Transitive test dependency | PASS: approved |
| Runtime libraries | None | PASS |
| Proposed `eclipse-temurin:17-jre-alpine` | Container base image | PASS: approved |

**Shadow IT result:** PASS - no unapproved dependencies were found.  
**Dependabot result:** FAIL - GitHub returned HTTP 403 because Dependabot alerts are disabled. Known-CVE status is therefore unverified.  
**Overall governance gate:** **FAIL** pending enablement or an approved exception for Dependabot security alerts.

## 4. Proposed Change

### Falsifiable Hypothesis

Replacing the concrete billing field in `OrdersService` with a `BillingClient` constructor dependency, while preserving a default constructor, will remove the direct coupling without changing order or billing behavior. The existing four contract tests plus an injected-client test can disconfirm this hypothesis.

### Allowlist

| File | Proposed change |
|---|---|
| `pom.xml` | Change compiler source, target, and release from Java 8 to Java 17 |
| `src/main/java/com/demo/billing/BillingClient.java` | Add the billing boundary interface |
| `src/main/java/com/demo/billing/BillingService.java` | Implement `BillingClient`; preserve billing logic |
| `src/main/java/com/demo/orders/OrdersService.java` | Use constructor injection with a compatibility default constructor |
| `src/test/java/com/demo/orders/OrdersBillingContractTest.java` | Add focused verification of the injected billing contract |
| `Dockerfile` | Add a multi-stage build and approved Java 17 runtime image; normalize `mvnw` CRLF before execution |
| `evidence/a2d-assessment.md` | Record pre-change assessment and approval gate |
| `evidence/approval-package.md` | Record post-change validation and draft PR evidence |

### Constraints

- Add no runtime dependencies.
- Change no billing or order business rules.
- Do not modify files outside the allowlist.
- Re-run compilation, tests, dependency tree, and allowlist verification after the change.
- Build `orders-service` and run it as the named container `orders-demo`; do not run the application directly.
- Do not merge or deploy.

### Risks and Hypotheses Requiring Human Verification

| Item | Type | Impact | Required verification |
|---|---|---|---|
| Consumers may rely on `new OrdersService()` | Hypothesis | Low | Preserve and test the no-argument constructor |
| Java 17 may expose compatibility issues outside current tests | Risk | Medium | Run clean verification on JDK 17 |
| Alpine-based image may conflict with undocumented native requirements | Hypothesis | Low | Build and run the container locally |
| Dependabot vulnerability state is unknown | Fact | High | Enable Dependabot alerts or approve a documented exception before final approval |

**Estimated implementation impact:** LOW  
**Approval gate:** **STOP - WAITING FOR HUMAN APPROVAL**

No source, build, or container changes may be applied until a human explicitly says `proceed`.