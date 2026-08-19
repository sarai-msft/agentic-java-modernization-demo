@echo off
REM ============================================================
REM A2D Approval Package Generator
REM Produces the "AI Generated Decision Package" for Demo 4
REM Creates: approval-package.md + mocked change request
REM ============================================================

echo ============================================================
echo  GENERATING A2D APPROVAL PACKAGE
echo ============================================================
echo.

echo [1/6] Collecting architecture summary...
echo   Application: Customer Ordering Service
echo   Change: Java 8 -^> Java 17, BillingClient module seam
echo   Scope: 4 files (pom.xml, BillingClient, BillingService, OrdersService)
echo.

echo [2/6] Collecting security findings...
echo   CVE scan: 0 critical, 0 high, 0 medium
echo   Dependency audit: All libraries on approved list
echo   Shadow IT check: PASS (no unapproved libraries)
echo.

echo [3/6] Collecting test results...
echo   OrdersBillingContractTest: 12/12 passed
echo   Regression: No failures
echo.

echo [4/6] Collecting SBOM...
echo   Format: SPDX 2.3
echo   Base image: eclipse-temurin:17-jre
echo   Application: orders-billing-monolith:1.0.0-SNAPSHOT
echo.

echo [5/6] Creating change request...
echo   Connecting to change management system...
echo   Change request created: CRQ-10452
echo.

echo [6/6] Assembling decision package...

REM Generate the approval package file
(
echo # AI Generated Decision Package
echo.
echo ## Application
echo Customer Ordering Service
echo.
echo ## Change Summary
echo Modernize from Java 8 to Java 17 with BillingClient module seam.
echo Scope limited to allowlisted files. No business logic changes.
echo.
echo ---
echo.
echo ^| Dimension             ^| Result                          ^|
echo ^|-----------------------^|---------------------------------^|
echo ^| Technical Debt        ^| **Reduced** ^(coupling removed^)   ^|
echo ^| Security Findings     ^| **0 Critical**                   ^|
echo ^| Tests                 ^| **12/12 Passed**                  ^|
echo ^| SBOM                  ^| **Attached** ^(SPDX 2.3^)          ^|
echo ^| Architecture Review   ^| **Passed** ^(readiness score 84%%^) ^|
echo ^| Governance Check      ^| **Passed** ^(no shadow IT^)        ^|
echo ^| Change Request        ^| **CRQ-10452 Created**             ^|
echo ^| PR                    ^| **Ready** ^(draft, evidence linked^)^|
echo.
echo ---
echo.
echo ## Evidence Links
echo - Build/test log: evidence/build-and-test.log
echo - Dependency inventory: evidence/dependency-tree.log
echo - SCA report: evidence/sca-report.md
echo - SBOM: fallback/06-sbom.spdx.json
echo - Dependency graph: evidence/dependency-graph.md
echo - Diff allowlist: evidence/diff-files.log
echo - Trace: evidence/trace.md
echo.
echo ---
echo.
echo ## Status
echo ```
echo +-------------------------------------------------+
echo ^|                                                 ^|
echo ^|        STATUS: WAITING FOR HUMAN APPROVAL       ^|
echo ^|                                                 ^|
echo ^|  Change Request: CRQ-10452                      ^|
echo ^|  PR: Draft ^(no merge permitted^)                 ^|
echo ^|  Deployment: Blocked until approved              ^|
echo ^|                                                 ^|
echo +-------------------------------------------------+
echo ```
echo.
echo The value is not that AI upgraded Java 8 to Java 17.
echo The value is that AI transformed a weeks-long A2D review
echo process into a governed evidence-driven workflow.
) > evidence\approval-package.md

echo.
echo ============================================================
echo  A2D DECISION PACKAGE COMPLETE
echo ============================================================
echo.
echo   Application:        Customer Ordering Service
echo   Technical Debt:      Reduced
echo   Security Findings:   0 Critical
echo   Tests:               12/12 Passed
echo   SBOM:                Attached
echo   Architecture Review: Passed
echo   Change Request:      CRQ-10452 Created
echo   PR:                  Ready
echo.
echo   +-----------------------------------------------+
echo   ^|                                               ^|
echo   ^|    STATUS: WAITING FOR HUMAN APPROVAL         ^|
echo   ^|                                               ^|
echo   +-----------------------------------------------+
echo.
echo   Saved to: evidence\approval-package.md
echo ============================================================
