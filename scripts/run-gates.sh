#!/usr/bin/env bash
set -euo pipefail
mkdir -p evidence

echo "Gate 1: compile and tests"
mvn clean test | tee evidence/build-and-test.log

echo ""
echo "Gate 2: dependency inventory"
mvn dependency:tree | tee evidence/dependency-tree.log

echo ""
echo "Gate 3: diff allowlist"
git diff --name-only main...HEAD | tee evidence/diff-files.log
