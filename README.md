# Agentic Java Modernization Demo

Demonstrates AI-driven Java 8 → Java 17 modernization using GitHub Copilot as an A2D (Acquire-to-Decommission) Modernization Agent.

## What This Is

A Java 8 monolith where `OrdersService` directly instantiates `BillingService` (tight coupling). GitHub Copilot, guided by `.github/copilot-instructions.md`, scans the repo, assesses risk, proposes changes, applies them, validates, and creates a draft PR — all autonomously with human approval gates.

## How It Works

1. Open this repo in VS Code with GitHub Copilot
2. Ask Copilot: *"What are your instructions for this repo?"*
3. Ask Copilot: *"A business request has arrived: Upgrade the Customer Ordering Service. Assess this repository."*
4. Copilot runs the 7-stage A2D lifecycle (Intake → Readiness → Governance → Propose → Apply → Validate → Approve)

## Running the Monolith

```bash
.\mvnw.cmd clean package -q
java -cp target\classes com.demo.Main
```

## Structure

- `.github/copilot-instructions.md` — The A2D agent instructions
- `src/` — Java 8 monolith source (3 files + 1 test)
- `scripts/fallback/` — Echo-based fallback scripts for offline demo
- `scripts/run-gates.cmd` — Maven test gate runner
