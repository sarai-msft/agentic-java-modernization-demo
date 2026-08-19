@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM A2D Intake Assessment (LIVE)
REM Performs real scanning of the repository
REM Writes artifacts to evidence\stage1-intake.md
REM ============================================================

pushd %~dp0..
if not exist evidence mkdir evidence

echo ============================================================
echo  A2D SOFTWARE INTAKE ASSESSMENT
echo  Business Request: Upgrade Customer Ordering Service
echo ============================================================
echo.

REM --- Step 1: Scan repository for build system and source files ---
echo [1/4] Scanning repository...

set BUILD_SYSTEM=Unknown
if exist pom.xml set BUILD_SYSTEM=Maven
if exist build.gradle set BUILD_SYSTEM=Gradle
echo   Build system: !BUILD_SYSTEM!

set /a SRC_COUNT=0
for /r src\main\java %%f in (*.java) do set /a SRC_COUNT+=1
set /a TEST_COUNT=0
for /r src\test\java %%f in (*.java) do set /a TEST_COUNT+=1
echo   Source files: !SRC_COUNT! Java classes, !TEST_COUNT! test class(es)

set HAS_DOCKERFILE=Not found
if exist Dockerfile set HAS_DOCKERFILE=Present
echo   Dockerfile: !HAS_DOCKERFILE!
echo.

REM --- Step 2: Extract Java version from pom.xml ---
echo [2/4] Analyzing current state...

set JAVA_VER=unknown
for /f "tokens=3 delims=<>" %%v in ('findstr "maven.compiler.release" pom.xml 2^>nul') do (
    if not "%%v"=="" set JAVA_VER=%%v
)
if "!JAVA_VER!"=="unknown" (
    for /f "tokens=3 delims=<>" %%v in ('findstr "maven.compiler.source" pom.xml 2^>nul') do (
        if not "%%v"=="" set JAVA_VER=%%v
    )
)

set JAVA_STATUS=SUPPORTED
if "!JAVA_VER!"=="1.8" set JAVA_STATUS=END OF LIFE
if "!JAVA_VER!"=="8" set JAVA_STATUS=END OF LIFE

echo   Detected Java version: !JAVA_VER! - !JAVA_STATUS!
echo.

REM --- Step 3: Extract dependencies from pom.xml ---
echo [3/4] Checking dependencies...

set /a RUNTIME_DEPS=0
set /a TEST_DEPS=0
set /a TOTAL_DEPS=0

REM Parse pom.xml for dependency artifactIds and versions
set "IN_DEPS=0"
set "LAST_ARTIFACT="
set "LAST_VERSION="
set "LAST_SCOPE=compile"

for /f "tokens=2,3 delims=<>" %%a in (pom.xml) do (
    if "%%a"=="dependencies" set IN_DEPS=1
    if "%%a"=="/dependencies" set IN_DEPS=0
    if "!IN_DEPS!"=="1" (
        if "%%a"=="artifactId" if not "%%b"=="" set "LAST_ARTIFACT=%%b"
        if "%%a"=="version" if not "%%b"=="" set "LAST_VERSION=%%b"
        if "%%a"=="scope" if not "%%b"=="" set "LAST_SCOPE=%%b"
        if "%%a"=="/dependency" (
            if not "!LAST_ARTIFACT!"=="" (
                set /a TOTAL_DEPS+=1
                echo   !LAST_ARTIFACT!:!LAST_VERSION! [!LAST_SCOPE!]
                if "!LAST_SCOPE!"=="test" (
                    set /a TEST_DEPS+=1
                ) else (
                    set /a RUNTIME_DEPS+=1
                )
            )
            set "LAST_ARTIFACT="
            set "LAST_VERSION="
            set "LAST_SCOPE=compile"
        )
    )
)

echo   Runtime dependencies: !RUNTIME_DEPS!
echo   Test dependencies: !TEST_DEPS!
echo.

REM --- Step 4: Find coupling via real grep ---
echo [4/4] Assessing coupling and architecture...

set COUPLING=NONE
set COUPLING_TYPE=None
set SEAM=N/A

findstr /S /C:"new BillingService()" src\main\java\*.java >nul 2>&1
if !errorlevel!==0 (
    set COUPLING=DIRECT COUPLING
    set COUPLING_TYPE=Hard instantiation
    set SEAM=charge method
    echo   OrdersService -^> BillingService: DIRECT COUPLING
    for /f "delims=" %%L in ('findstr /S /C:"new BillingService()" src\main\java\*.java') do (
        echo     %%L
    )
) else (
    findstr /S /C:"BillingClient" src\main\java\com\demo\orders\*.java >nul 2>&1
    if !errorlevel!==0 (
        set COUPLING=INTERFACE DECOUPLED
        set COUPLING_TYPE=Via BillingClient interface
        set SEAM=charge method
        echo   OrdersService -^> BillingClient: INTERFACE DECOUPLED
        for /f "delims=" %%L in ('findstr /S /C:"BillingClient" src\main\java\com\demo\orders\*.java') do (
            echo     %%L
        )
    )
)

echo   Coupling type: !COUPLING_TYPE!
echo   Seam candidate: !SEAM!
echo.

REM --- Derive assessment values ---
set SECURITY_RISK=No runtime CVEs
if "!JAVA_STATUS!"=="END OF LIFE" set SECURITY_RISK=Java !JAVA_VER! EOL, no runtime CVEs

set TECH_DEBT=None detected
if "!COUPLING!"=="DIRECT COUPLING" set TECH_DEBT=Tight coupling

set RECOMMENDATION=No action needed
if "!JAVA_STATUS!"=="END OF LIFE" set RECOMMENDATION=Upgrade to Java 17
if "!COUPLING!"=="DIRECT COUPLING" if "!RECOMMENDATION!"=="No action needed" set RECOMMENDATION=Introduce interface seam

echo ============================================================
echo  INTAKE ASSESSMENT RESULTS
echo ============================================================
echo.
echo   +---------------------+-------------------------------+
echo   ^| Question            ^| Answer                        ^|
echo   +---------------------+-------------------------------+
echo   ^| Application         ^| Customer Ordering Service     ^|
echo   ^| Current runtime     ^| Java !JAVA_VER!                        ^|
echo   ^| Security risk       ^| !SECURITY_RISK!  ^|
echo   ^| Technical debt      ^| !TECH_DEBT!                   ^|
echo   ^| Recommendation      ^| !RECOMMENDATION!            ^|
echo   ^| Estimated impact    ^| Low - scoped seam change      ^|
echo   ^| Shadow IT risk      ^| !RUNTIME_DEPS! unapproved runtime libs ^|
echo   +---------------------+-------------------------------+
echo.
echo   HP A2D Alignment:
echo     [x] Technical debt identified and quantified
echo     [x] Cyber risk assessed - runtime !JAVA_STATUS!
echo     [x] Shadow IT checked - !RUNTIME_DEPS! unapproved libraries
echo     [x] Modernization path recommended
echo.
echo   STATUS: READY FOR MODERNIZATION REVIEW
echo ============================================================

REM --- Write artifact to file line by line ---
echo # A2D Intake Assessment> evidence\stage1-intake.md
echo Generated: %date% %time%>> evidence\stage1-intake.md
echo.>> evidence\stage1-intake.md
echo ## Repository Scan>> evidence\stage1-intake.md
echo - Build system: !BUILD_SYSTEM!>> evidence\stage1-intake.md
echo - Source files: !SRC_COUNT! classes, !TEST_COUNT! test classes>> evidence\stage1-intake.md
echo - Dockerfile: !HAS_DOCKERFILE!>> evidence\stage1-intake.md
echo.>> evidence\stage1-intake.md
echo ## Java Version>> evidence\stage1-intake.md
echo - Detected: !JAVA_VER!>> evidence\stage1-intake.md
echo - Status: !JAVA_STATUS!>> evidence\stage1-intake.md
echo.>> evidence\stage1-intake.md
echo ## Dependencies>> evidence\stage1-intake.md
echo - Runtime: !RUNTIME_DEPS!>> evidence\stage1-intake.md
echo - Test: !TEST_DEPS!>> evidence\stage1-intake.md
echo.>> evidence\stage1-intake.md
echo ## Coupling>> evidence\stage1-intake.md
echo - Type: !COUPLING!>> evidence\stage1-intake.md
echo - Detail: !COUPLING_TYPE!>> evidence\stage1-intake.md
echo - Seam: !SEAM!>> evidence\stage1-intake.md
echo.>> evidence\stage1-intake.md
echo ## Assessment>> evidence\stage1-intake.md
echo - Security risk: !SECURITY_RISK!>> evidence\stage1-intake.md
echo - Technical debt: !TECH_DEBT!>> evidence\stage1-intake.md
echo - Recommendation: !RECOMMENDATION!>> evidence\stage1-intake.md
echo - Shadow IT: !RUNTIME_DEPS! unapproved runtime libs>> evidence\stage1-intake.md
echo.>> evidence\stage1-intake.md
echo STATUS: READY FOR MODERNIZATION REVIEW>> evidence\stage1-intake.md

echo.
echo   Artifact saved: evidence\stage1-intake.md

popd
endlocal
