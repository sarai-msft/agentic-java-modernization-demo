@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM A2D Governance Check (LIVE)
REM Validates libraries against approved list
REM Checks Dockerfile base image, prevents shadow IT
REM Writes artifact to evidence\stage3-governance.md
REM ============================================================

pushd %~dp0..
if not exist evidence mkdir evidence

echo ============================================================
echo  A2D GOVERNANCE CHECK
echo  Policy: All libraries must be on the approved list
echo ============================================================
echo.

REM --- Approved library registry (add entries as needed) ---
set "APPROVED=junit hamcrest-core mockito-core spring-boot-starter log4j-api slf4j-api jackson-databind"
set "APPROVED_IMAGES=eclipse-temurin openjdk mcr.microsoft.com"

REM --- Step 1: Extract dependencies from pom.xml ---
echo [1/3] Extracting dependency list...

set /a TOTAL_DEPS=0
set /a APPROVED_COUNT=0
set /a UNAPPROVED_COUNT=0
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
                set "IS_APPROVED=NO"
                for %%L in (%APPROVED%) do (
                    if "!LAST_ARTIFACT!"=="%%L" set "IS_APPROVED=YES"
                )
                echo   !LAST_ARTIFACT!:!LAST_VERSION! [!LAST_SCOPE!] - !IS_APPROVED!
                if "!IS_APPROVED!"=="YES" (
                    set /a APPROVED_COUNT+=1
                ) else (
                    set /a UNAPPROVED_COUNT+=1
                )
            )
            set "LAST_ARTIFACT="
            set "LAST_VERSION="
            set "LAST_SCOPE=compile"
        )
    )
)

set /a RUNTIME_DEPS=0
echo.

REM --- Step 2: Check against approved registry (table format) ---
echo [2/3] Checking against approved library registry...
echo.
echo   +-------------------------------+----------+-----------+
echo   ^| Library                       ^| Scope    ^| Approved  ^|
echo   +-------------------------------+----------+-----------+

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
                set "IS_APPROVED=NO"
                for %%L in (%APPROVED%) do (
                    if "!LAST_ARTIFACT!"=="%%L" set "IS_APPROVED=YES"
                )
                echo   ^| !LAST_ARTIFACT!:!LAST_VERSION!	^| !LAST_SCOPE!	^| !IS_APPROVED!       ^|
            )
            set "LAST_ARTIFACT="
            set "LAST_VERSION="
            set "LAST_SCOPE=compile"
        )
    )
)

REM --- Check Dockerfile base image ---
set "DOCKER_IMAGE=none"
set "DOCKER_APPROVED=NO"
if exist Dockerfile (
    for /f "tokens=2" %%i in ('findstr /R "^FROM" Dockerfile') do (
        set "DOCKER_IMAGE=%%i"
        for %%A in (%APPROVED_IMAGES%) do (
            echo %%i | findstr /C:"%%A" >nul 2>&1
            if !errorlevel!==0 set "DOCKER_APPROVED=YES"
        )
    )
    echo   ^| !DOCKER_IMAGE!	^| base img	^| !DOCKER_APPROVED!       ^|
)

echo   +-------------------------------+----------+-----------+
echo.
echo   Unapproved libraries found: !UNAPPROVED_COUNT!
if !UNAPPROVED_COUNT! equ 0 (
    echo   Shadow IT risk: NONE
) else (
    echo   Shadow IT risk: HIGH - !UNAPPROVED_COUNT! unapproved libraries detected
)
echo.

REM --- Step 3: Check runtime support ---
echo [3/3] Checking runtime support...
set JAVA_VER=unknown
for /f "tokens=3 delims=<>" %%v in ('findstr "maven.compiler.release" pom.xml 2^>nul') do (
    if not "%%v"=="" set JAVA_VER=%%v
)

set "RUNTIME_STATUS=UNKNOWN"
set "RUNTIME_EOL=N/A"
if "!JAVA_VER!"=="17" set "RUNTIME_STATUS=SUPPORTED" & set "RUNTIME_EOL=Sep 2029"
if "!JAVA_VER!"=="21" set "RUNTIME_STATUS=SUPPORTED" & set "RUNTIME_EOL=Sep 2031"
if "!JAVA_VER!"=="11" set "RUNTIME_STATUS=NEARING EOL" & set "RUNTIME_EOL=Sep 2026"
if "!JAVA_VER!"=="8" set "RUNTIME_STATUS=END OF LIFE" & set "RUNTIME_EOL=Mar 2025"
if "!JAVA_VER!"=="1.8" set "RUNTIME_STATUS=END OF LIFE" & set "RUNTIME_EOL=Mar 2025"

echo   Java !JAVA_VER!: !RUNTIME_STATUS! (until !RUNTIME_EOL!)
echo.

REM --- Final result ---
set "RESULT=PASS"
if !UNAPPROVED_COUNT! gtr 0 set "RESULT=FAIL"
if "!DOCKER_APPROVED!"=="NO" if exist Dockerfile set "RESULT=FAIL"

echo ============================================================
if "!RESULT!"=="PASS" (
    echo  GOVERNANCE RESULT: PASS
    echo  All libraries approved. No shadow IT detected.
) else (
    echo  GOVERNANCE RESULT: FAIL
    echo  !UNAPPROVED_COUNT! unapproved libraries detected.
    echo  Action required before proceeding.
)
echo ============================================================

REM --- Write artifact ---
echo # A2D Governance Check> evidence\stage3-governance.md
echo Generated: %date% %time%>> evidence\stage3-governance.md
echo.>> evidence\stage3-governance.md
echo ## Dependencies Checked: !TOTAL_DEPS!>> evidence\stage3-governance.md
echo - Approved: !APPROVED_COUNT!>> evidence\stage3-governance.md
echo - Unapproved: !UNAPPROVED_COUNT!>> evidence\stage3-governance.md
echo.>> evidence\stage3-governance.md
echo ## Docker Base Image>> evidence\stage3-governance.md
echo - Image: !DOCKER_IMAGE!>> evidence\stage3-governance.md
echo - Approved: !DOCKER_APPROVED!>> evidence\stage3-governance.md
echo.>> evidence\stage3-governance.md
echo ## Runtime>> evidence\stage3-governance.md
echo - Java: !JAVA_VER!>> evidence\stage3-governance.md
echo - Status: !RUNTIME_STATUS!>> evidence\stage3-governance.md
echo - EOL: !RUNTIME_EOL!>> evidence\stage3-governance.md
echo.>> evidence\stage3-governance.md
echo ## Result: !RESULT!>> evidence\stage3-governance.md

echo.
echo   Artifact saved: evidence\stage3-governance.md

popd
endlocal
