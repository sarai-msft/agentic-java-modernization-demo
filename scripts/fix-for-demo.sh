#!/usr/bin/env bash
set -euo pipefail

# Reverts the deliberate failure introduced by break-for-demo.sh
echo "Fixing BillingService validation..."

sed -i 's/amount == null/amount == null || amount.compareTo(BigDecimal.ZERO) <= 0/' \
    src/main/java/com/demo/billing/BillingService.java

echo "Done. Run 'mvn clean test' to confirm all 12 tests pass again."
