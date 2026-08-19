# AI Decision Package — CRQ-10452

**Application:** Orders Billing Monolith (`com.demo:orders-billing-monolith:1.0.0-SNAPSHOT`)
**Date:** 2026-08-20
**Change Request:** CRQ-10452
**PR:** https://github.com/sarai-msft/agentic-java-modernization-demo/pull/1

---

## Change Summary

| Item | Before | After |
|---|---|---|
| Java runtime | 1.8 / 8 (EOL) | 17 (LTS) |
| Coupling | Direct `new BillingService()` | Interface `BillingClient` + constructor injection |
| Containerization | None | Dockerfile with `eclipse-temurin:17-jre-alpine` |
| Runtime dependencies | 0 | 0 (unchanged) |

## Technical Debt

**Reduced** — EOL runtime eliminated, tight coupling replaced with interface boundary, containerization added.

## Security Findings

**0 critical** — Java 17 LTS, no vulnerable dependencies, approved base image.

## Test Results

| Metric | Value |
|---|---|
| Tests run | 4 |
| Failures | 0 |
| Errors | 0 |
| Skipped | 0 |

## Governance Result

**PASS** — All dependencies on approved list. Base image `eclipse-temurin:17-jre-alpine` approved. No shadow IT detected.

## Validation Gates

| Gate | Result |
|---|---|
| Compile & Test | PASS |
| App Run | PASS |
| Docker Build | PASS |
| Docker Run (named container) | PASS |
| Diff Allowlist | PASS |
| New Runtime Dependencies | PASS (0 added) |

---

```
STATUS: WAITING FOR HUMAN APPROVAL
Change Request: CRQ-10452
PR: https://github.com/sarai-msft/agentic-java-modernization-demo/pull/1
Deployment: Blocked until approved
```
