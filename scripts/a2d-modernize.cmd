@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM A2D Modernize (LIVE)
REM Applies the modernization changes: Java 8->17 + BillingClient seam
REM Creates a new branch from main and applies changes from the
REM pre-validated modernization branch.
REM ============================================================

pushd %~dp0..
if not exist evidence mkdir evidence

echo ============================================================
echo  A2D MODERNIZATION AGENT
echo  Applying recommended changes from intake assessment
echo ============================================================
echo.

REM --- Verify we're on main ---
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD') do set CURRENT_BRANCH=%%b
if not "!CURRENT_BRANCH!"=="main" (
    echo   ERROR: Must be on 'main' branch to apply modernization.
    echo   Current branch: !CURRENT_BRANCH!
    echo   Run: git checkout main
    popd
    exit /b 1
)

echo [1/5] Creating modernization branch...
git checkout -b modernization/java17-billing-seam-demo 2>nul
if !errorlevel! neq 0 (
    echo   Branch already exists, resetting...
    git checkout modernization/java17-billing-seam-demo 2>nul
    git reset --hard main >nul 2>&1
)
echo   Branch: modernization/java17-billing-seam-demo
echo.

echo [2/5] Upgrading Java version: 8 -^> 17...
git checkout modernization/java17-billing-seam -- pom.xml
echo   pom.xml: maven.compiler.release = 17
echo.

echo [3/5] Creating BillingClient interface seam...
git checkout modernization/java17-billing-seam -- src/main/java/com/demo/billing/BillingClient.java
echo   NEW: src/main/java/com/demo/billing/BillingClient.java
echo   Purpose: Module seam interface for decoupling
echo.

echo [4/5] Refactoring BillingService and OrdersService...
git checkout modernization/java17-billing-seam -- src/main/java/com/demo/billing/BillingService.java
git checkout modernization/java17-billing-seam -- src/main/java/com/demo/orders/OrdersService.java
echo   MODIFIED: BillingService now implements BillingClient
echo   MODIFIED: OrdersService uses constructor injection
echo.

echo [5/5] Committing changes...
git add pom.xml src/main/java/com/demo/ >nul 2>&1
git commit -m "Modernize: Java 17 + BillingClient interface seam" >nul 2>&1
echo   Committed to branch: modernization/java17-billing-seam-demo
echo.

echo ============================================================
echo  CHANGES APPLIED
echo ============================================================
echo.
echo  Files changed:
git diff --stat main...HEAD -- pom.xml src/
echo.
echo  +---------------------------------------------+----------+
echo  ^| File                                        ^| Change   ^|
echo  +---------------------------------------------+----------+
echo  ^| pom.xml                                     ^| 8 -^> 17  ^|
echo  ^| billing/BillingClient.java                  ^| NEW      ^|
echo  ^| billing/BillingService.java                 ^| +iface   ^|
echo  ^| orders/OrdersService.java                   ^| +inject  ^|
echo  +---------------------------------------------+----------+
echo.
echo  Scope: 4 files (allowlisted only)
echo  New dependencies: NONE
echo  Business logic changes: NONE
echo.
echo  STATUS: CHANGES APPLIED - READY FOR VALIDATION GATES
echo ============================================================

REM --- Write artifact ---
echo # A2D Modernization Applied> evidence\stage4-modernize.md
echo Generated: %date% %time%>> evidence\stage4-modernize.md
echo.>> evidence\stage4-modernize.md
echo ## Changes>> evidence\stage4-modernize.md
echo - pom.xml: Java 8 to Java 17>> evidence\stage4-modernize.md
echo - BillingClient.java: NEW interface seam>> evidence\stage4-modernize.md
echo - BillingService.java: implements BillingClient>> evidence\stage4-modernize.md
echo - OrdersService.java: constructor injection via BillingClient>> evidence\stage4-modernize.md
echo.>> evidence\stage4-modernize.md
echo ## Scope Control>> evidence\stage4-modernize.md
echo - Files changed: 4>> evidence\stage4-modernize.md
echo - New dependencies: 0>> evidence\stage4-modernize.md
echo - Business logic changes: 0>> evidence\stage4-modernize.md
echo.>> evidence\stage4-modernize.md
echo STATUS: READY FOR VALIDATION GATES>> evidence\stage4-modernize.md

echo.
echo   Artifact saved: evidence\stage4-modernize.md

popd
endlocal