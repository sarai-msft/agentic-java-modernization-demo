# AI Decision Package — CRQ-10452

**Date:** 2026-08-20  
**Branch:** `modernize/java17-billing-seam`  
**PR:** https://github.com/sarai-msft/agentic-java-modernization-demo/pull/6  
**Change Request:** CRQ-10452  

---

## Architecture Summary

**Before:** Java 8 monolith with tight coupling (`OrdersService` directly instantiates `BillingService`). No containerization. Zero runtime dependencies.

**After:** Java 17 with interface seam (`BillingClient`) and constructor injection. Dockerized with `eclipse-temurin:17-jre-alpine`. Zero runtime dependencies (unchanged).

### Files Changed (8)
| File | Action |
|---|---|
| pom.xml | Java 1.8 → 17 |
| BillingClient.java | NEW — interface seam |
| BillingService.java | Implements BillingClient |
| OrdersService.java | Constructor injection via BillingClient |
| Main.java | Wires BillingService into OrdersService |
| OrdersBillingContractTest.java | Updated constructor call |
| Dockerfile | NEW — multi-stage build |
| evidence/a2d-assessment.md | NEW — assessment evidence |

---

## Security Findings

- Java 8 EOL runtime **remediated** → Java 17 (LTS, supported until 2029+)
- Zero runtime dependencies — no CVE surface
- Dependabot alerts disabled on repo (recommend enabling)
- Base image `eclipse-temurin:17-jre-alpine` — approved, maintained by Adoptium

---

## Test Results

| Metric | Result |
|---|---|
| Tests Run | 4 |
| Tests Passed | 4 |
| Tests Failed | 0 |
| Compilation Warnings | 0 |

---

## Governance Result

| Check | Result |
|---|---|
| Approved libraries | PASS |
| Shadow IT | PASS — none detected |
| New runtime deps | PASS — zero added |
| Diff allowlist | PASS — 8 files, all approved |
| Post-upgrade dep tree | PASS — identical to pre-upgrade |

---

## Docker Validation

- Image: `orders-service:latest`
- Base: `eclipse-temurin:17-jre-alpine`
- Container: `orders-demo` — ran successfully
- Output: Identical to pre-upgrade (business logic unchanged)

---

## STATUS: WAITING FOR HUMAN APPROVAL

This PR is in **draft** state. A human reviewer must:
1. Review the diff at the PR link above
2. Verify the hypotheses in the assessment
3. Mark the PR as ready and merge
