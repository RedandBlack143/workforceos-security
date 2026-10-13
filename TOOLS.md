# Aegis-Shield Security Tooling Guide

## 1. Quick Start
To run all security checks locally before pushing code, execute:
`./scan.sh`
Reports will be generated in the `findings/reports/` directory.

## 2. Tools Overview (Strengths & Limits)
*   **pip-audit / npm audit (Dependency Scanners):**
    *   **Finds:** Known CVEs in third-party open-source packages.
    *   **Misses:** Zero-days, malicious typosquatted packages, or vulnerabilities in your custom source code.
    *   **Time:** Fast (seconds).
*   **Gitleaks (Secret Scanner):**
    *   **Finds:** Hardcoded passwords, API keys, and tokens in current code and past Git commits.
    *   **Misses:** Passwords dynamically loaded at runtime or customized keys not matching its regex libraries.
    *   **Time:** Fast (seconds).
*   **OWASP ZAP (DAST - Dynamic Application Security Testing):**
    *   **Finds:** Runtime vulnerabilities like missing security headers, XSS, and misconfigurations on a running app.
    *   **Misses:** Deep business-logic flaws or back-end source code vulnerabilities.
    *   **Time:** Slow (minutes to hours depending on spider depth).

## 3. False Alarm (False Positive) Handling
*   **Dependencies:** If a CVE is flagged in a package that is never executed in our environment (e.g., a dev-dependency), add it to pip-audit's `--ignore` list or `.npmrc` overrides with a documented justification.
*   **Gitleaks:** If it flags a mock token used strictly for unit tests, create a `.gitleaksignore` file and add the specific rule or file path.
*   **ZAP:** If ZAP flags a missing anti-CSRF token on a stateless API endpoint (which relies securely on JWTs instead), mark it as a false positive in a ZAP `.context` file.

## 4. CI/CD Pipeline Integration (DevOps Agreement)
We have agreed with the DevOps team to integrate these tools into the CI/CD pipeline as follows:
1.  **Pre-Commit (Local):** `gitleaks` runs locally as a pre-commit hook to prevent secrets from ever reaching GitHub.
2.  **Build Stage (CI):** `pip-audit` and `npm audit` run. The build will fail if High/Critical vulnerabilities are found.
3.  **Post-Deployment (QA/Staging):** `OWASP ZAP` runs automatically against the staging environment after deployment. Results are posted to the security dashboard for triage; it does not block the build pipeline.
