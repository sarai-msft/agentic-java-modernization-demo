---
mode: agent
description: "A2D Modernization Workflow — Full intake-to-approval"
tools:
  - run_in_terminal
  - read_file
  - create_file
  - replace_string_in_file
  - list_dir
  - grep_search
---

# A2D Modernization Assessment

A business request has arrived: **Upgrade the Customer Ordering Service.**

You are the A2D Modernization Agent. Execute the full intake workflow:

## Step 1: INTAKE
Scan this repository. Find:
- Build system (pom.xml or build.gradle)
- Java runtime version (from maven.compiler.source/target/release in pom.xml)
- Source file count (main + test)
- Dockerfile presence
- Dependencies (from pom.xml — separate runtime vs test scope)
- Coupling (grep for "new.*Service()" in src/main/java — flag direct instantiation)

Present findings as a risk assessment table.

## Step 2: READINESS SCORE
Based on your scan, score these dimensions (0-100 each):
- Dependency health (fewer runtime deps = higher)
- Security findings (EOL runtime = deduction)
- Test coverage (count @Test annotations, more = higher)
- Runtime support (Java 17/21 = 100, Java 8 = 40)
- Coupling complexity (fewer "new Service()" = higher)

Compute the average as the Modernization Readiness Score.

## Step 3: GOVERNANCE
Check each dependency against the approved list: junit, hamcrest-core, mockito-core, spring-boot-starter, log4j-api, slf4j-api, jackson-databind.
Check Dockerfile base images against: eclipse-temurin, openjdk, mcr.microsoft.com.
Report PASS or FAIL.

## Step 4: PROPOSE
Based on ALL findings above, propose the modernization plan:
- What specific files need to change
- What the change is for each file
- What risks or hypotheses need human verification
- Estimated impact

Then STOP and ask: "Shall I proceed with these changes?"

DO NOT apply changes until the human says "proceed" or "yes".
