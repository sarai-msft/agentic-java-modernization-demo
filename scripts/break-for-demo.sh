#!/usr/bin/env bash
set -euo pipefail

# Introduces a deliberate test failure for demo purposes.
# Shows the gate catching a regression before it reaches the PR.
# Usage: bash scripts/break-for-demo.sh  (introduces failure)
#        bash scripts/fix-for-demo.sh    (reverts the failure)

echo "Introducing deliberate failure in BillingService..."
echo "Changing amount validation to allow zero (introduces bug)..."

sed -i 's/amount.compareTo(BigDecimal.ZERO) <= 0/amount == null/' \
    src/main/java/com/demo/billing/BillingService.java

echo "Done. Now run 'mvn clean test' to see the gate catch it."
echo "Expected: testBillingRejectsZeroAmount and testBillingRejectsNegativeAmount will FAIL"
