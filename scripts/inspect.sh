#!/usr/bin/env bash
set -euo pipefail

echo "Build files"
find . -name pom.xml -o -name build.gradle

echo ""
echo "Java version hints"
grep -R "maven.compiler.source\|maven.compiler.target\|maven.compiler.release" pom.xml || true

echo ""
echo "Orders to Billing call sites"
grep -R "BillingService\|BillingClient\|charge(" src/main/java src/test/java || true
