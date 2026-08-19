@echo off
REM Windows equivalent of scripts/inspect.sh
echo === Build files ===
dir /b /s pom.xml 2>nul
dir /b /s build.gradle 2>nul

echo.
echo === Java version hints ===
findstr /R "maven.compiler.source maven.compiler.target maven.compiler.release" pom.xml

echo.
echo === Orders to Billing call sites ===
findstr /S /R "BillingService BillingClient charge(" src\main\java\*.java src\test\java\*.java
