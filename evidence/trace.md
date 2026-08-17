# Decision Trace

## Modernization Goal
Upgrade Orders/Billing monolith from Java 8 to Java 17 with minimal scoped change.

## Steps Taken
1. **Inspect** — Identified pom.xml with Java 8 compiler settings, direct BillingService coupling in OrdersService
2. **Analyze** — Determined smallest safe change: update compiler target + introduce BillingClient seam
3. **Validate** — Ran compile, tests, dependency tree, and diff allowlist
4. **Propose** — Created draft PR with evidence links, held for human approval

## Decisions
- Kept change limited to pom.xml, BillingClient.java, and OrdersService.java
- Did not refactor unrelated code
- Used contract test to prove seam behavior
- Draft PR only — no merge or deployment
