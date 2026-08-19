@echo off
REM Windows equivalent of scripts/run-gates.sh
if not exist evidence mkdir evidence

echo === Gate 1: compile and tests ===
call mvnw.cmd clean test > evidence\build-and-test.log 2>&1
type evidence\build-and-test.log | findstr /R "Tests.run BUILD"

echo.
echo === Gate 2: dependency inventory ===
call mvnw.cmd dependency:tree > evidence\dependency-tree.log 2>&1
echo Saved to evidence\dependency-tree.log

echo.
echo === Gate 3: diff allowlist ===
git diff --name-only main...HEAD > evidence\diff-files.log
type evidence\diff-files.log
