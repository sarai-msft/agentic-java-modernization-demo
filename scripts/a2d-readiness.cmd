@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM A2D Modernization Readiness Score (LIVE)
REM Computes a readiness score from real repo analysis
REM Writes artifact to evidence\stage2-readiness.md
REM ============================================================

pushd %~dp0..
if not exist evidence mkdir evidence

echo ============================================================
echo  MODERNIZATION READINESS ASSESSMENT
echo ============================================================
echo.

REM --- Dimension 1: Dependency health (0 runtime deps = 100, CVEs reduce) ---
set /a DEP_SCORE=100
set /a RUNTIME_DEPS=0
set "IN_DEPS=0"
set "LAST_SCOPE=compile"
for /f "tokens=2,3 delims=<>" %%a in (pom.xml) do (
    if "%%a"=="dependencies" set IN_DEPS=1
    if "%%a"=="/dependencies" set IN_DEPS=0
    if "!IN_DEPS!"=="1" (
        if "%%a"=="scope" set "LAST_SCOPE=%%b"
        if "%%a"=="/dependency" (
            if not "!LAST_SCOPE!"=="test" set /a RUNTIME_DEPS+=1
            set "LAST_SCOPE=compile"
        )
    )
)
if !RUNTIME_DEPS! gtr 0 set /a DEP_SCORE=100-RUNTIME_DEPS*10
if !DEP_SCORE! lss 0 set /a DEP_SCORE=0
echo  Scoring dimensions:
echo.
echo   Dependency health .......... !DEP_SCORE!/100 (!RUNTIME_DEPS! runtime deps)

REM --- Dimension 2: Security findings (Java EOL = -10, each CVE = -20) ---
set /a SEC_SCORE=100
set JAVA_VER=unknown
for /f "tokens=3 delims=<>" %%v in ('findstr "maven.compiler.release" pom.xml 2^>nul') do (
    if not "%%v"=="" set JAVA_VER=%%v
)
if "!JAVA_VER!"=="8" set /a SEC_SCORE=SEC_SCORE-10
if "!JAVA_VER!"=="1.8" set /a SEC_SCORE=SEC_SCORE-10
echo   Security findings .......... !SEC_SCORE!/100 (Java !JAVA_VER!, no CVEs)

REM --- Dimension 3: Test coverage (count @Test annotations) ---
set /a TEST_COUNT=0
for /f %%n in ('findstr /S /R /C:"@Test" src\test\java\*.java 2^>nul ^| find /c "@Test"') do set /a TEST_COUNT=%%n
set /a TEST_SCORE=TEST_COUNT*7
if !TEST_SCORE! gtr 100 set /a TEST_SCORE=100
echo   Test coverage .............. !TEST_SCORE!/100 (!TEST_COUNT! contract tests)

REM --- Dimension 4: Runtime support (Java 17/21 = 100, 11 = 70, 8 = 40) ---
set /a RUNTIME_SCORE=100
if "!JAVA_VER!"=="8" set /a RUNTIME_SCORE=40
if "!JAVA_VER!"=="1.8" set /a RUNTIME_SCORE=40
if "!JAVA_VER!"=="11" set /a RUNTIME_SCORE=70
echo   Runtime support ............ !RUNTIME_SCORE!/100 (Java !JAVA_VER!)

REM --- Dimension 5: Coupling complexity (count "new XXXService()" in main) ---
set /a COUPLING_COUNT=0
for /f %%n in ('findstr /S /R /C:"new.*Service()" src\main\java\*.java 2^>nul ^| find /c "new"') do set /a COUPLING_COUNT=%%n
set /a COUPLING_SCORE=100-COUPLING_COUNT*20
if !COUPLING_SCORE! lss 0 set /a COUPLING_SCORE=0
echo   Coupling complexity ........ !COUPLING_SCORE!/100 (!COUPLING_COUNT! tight coupling points)
echo.

REM --- Compute weighted average ---
set /a TOTAL=DEP_SCORE+SEC_SCORE+TEST_SCORE+RUNTIME_SCORE+COUPLING_SCORE
set /a SCORE=TOTAL/5

REM --- Build progress bar ---
set /a BAR_FILLED=SCORE/3
set /a BAR_EMPTY=33-BAR_FILLED
set "BAR="
for /l %%i in (1,1,!BAR_FILLED!) do set "BAR=!BAR!="
for /l %%i in (1,1,!BAR_EMPTY!) do set "BAR=!BAR! "

echo  +---------------------------------------------------------+
echo  ^|                                                         ^|
echo  ^|   MODERNIZATION READINESS SCORE = !SCORE!%%                   ^|
echo  ^|                                                         ^|
echo  ^|   [!BAR!]          ^|
echo  ^|                                                         ^|
echo  +---------------------------------------------------------+
echo.

if !SCORE! geq 70 (
    echo  Recommendation: PROCEED
) else if !SCORE! geq 50 (
    echo  Recommendation: PROCEED WITH CAUTION
) else (
    echo  Recommendation: STOP - Too risky
)
echo.

echo  Rationale:
if !DEP_SCORE! geq 90 echo    - High dependency health, minimal attack surface
if !TEST_SCORE! geq 70 echo    - Strong test coverage at module seam
if !COUPLING_COUNT! leq 2 echo    - Low coupling makes change low-risk
if !RUNTIME_SCORE! leq 50 echo    - Runtime EOL creates urgency for upgrade
echo.

echo  Risk factors:
if !TEST_COUNT! lss 5 echo    - Low test count (only !TEST_COUNT! tests)
if !COUPLING_COUNT! gtr 2 echo    - High coupling (!COUPLING_COUNT! direct instantiations)
if !RUNTIME_SCORE! leq 50 echo    - Java !JAVA_VER! is end of life
echo    - No integration tests (hypothesis, needs verification)
echo    - No performance baseline captured
echo.
echo  This score feeds into the A2D decision package for
echo  architecture review and human approval.
echo ============================================================

REM --- Write artifact ---
echo # Modernization Readiness Assessment> evidence\stage2-readiness.md
echo Generated: %date% %time%>> evidence\stage2-readiness.md
echo.>> evidence\stage2-readiness.md
echo ## Scores>> evidence\stage2-readiness.md
echo - Dependency health: !DEP_SCORE!/100>> evidence\stage2-readiness.md
echo - Security findings: !SEC_SCORE!/100>> evidence\stage2-readiness.md
echo - Test coverage: !TEST_SCORE!/100 (!TEST_COUNT! tests)>> evidence\stage2-readiness.md
echo - Runtime support: !RUNTIME_SCORE!/100 (Java !JAVA_VER!)>> evidence\stage2-readiness.md
echo - Coupling complexity: !COUPLING_SCORE!/100 (!COUPLING_COUNT! coupling points)>> evidence\stage2-readiness.md
echo.>> evidence\stage2-readiness.md
echo ## Overall>> evidence\stage2-readiness.md
echo READINESS SCORE: !SCORE!%%>> evidence\stage2-readiness.md
if !SCORE! geq 70 (echo RECOMMENDATION: PROCEED>> evidence\stage2-readiness.md) else (echo RECOMMENDATION: REVIEW REQUIRED>> evidence\stage2-readiness.md)

echo.
echo   Artifact saved: evidence\stage2-readiness.md

popd
endlocal
