# Task 2: Security Requirements & Secure Coding Standard

## 1. Target ASVS Level
**Target Level: ASVS Level 2 (Standard)**
* **Why Level 2?** Level 1 is meant for basic applications with low risk. Because WorkforceOS handles highly sensitive financial data (payroll, bank details, expenses) and PII (Personal Identifiable Information), it requires a stricter baseline. ASVS Level 2 is the recommended standard for applications that process sensitive business-to-business transactions, healthcare data, or financial information.

## 2. Top 10 Threats & Security Requirements

| Rank | Threat | Testable Security Requirement | ASVS Ref | OWASP Cheat Sheet |
| :--- | :--- | :--- | :--- | :--- |
| 1 | **TR-15:** IDOR on payslips | The backend must verify the authenticated user's authorization to access the specific `employee_id` requested before returning data. | V4.1.1 (Access Control) | Authorization Cheat Sheet |
| 2 | **TR-17:** AI Prompt Injection | The AI service must use strict system prompt boundaries and validate/sanitize all user inputs before passing them to the LLM. | V5.3.4 (Input Validation) | LLM AI Security & Privacy Guide |
| 3 | **TR-18:** Cleartext logging | The application must mask or remove passwords, tokens, and PII from all application and system logs. | V7.1.1 (Logging) | Logging Cheat Sheet |
| 4 | **TR-01:** Password brute-forcing | The login endpoint must implement rate-limiting and account lockout mechanisms after a set number of failed attempts. | V2.1.1 (Authentication) | Authentication Cheat Sheet |
| 5 | **TR-21:** Volumetric DoS | The reverse proxy must implement IP-based rate limiting and traffic filtering for all incoming public requests. | V11.1.4 (Business Logic) | Denial of Service Cheat Sheet |
| 6 | **TR-26:** JWT Role manipulation | The backend must cryptographically verify the signature of all JWTs using a securely stored secret before trusting the role claim. | V3.5.2 (Session Mgt) | JSON Web Token Cheat Sheet |
| 7 | **TR-16:** Internal network sniffing | All internal communication between the proxy, backend, and data stores must be encrypted using TLS 1.2 or higher. | V9.1.1 (Communications) | Transport Layer Protection |
| 8 | **TR-02:** Session token hijacking | Session tokens must be generated with high entropy and set with `Secure`, `HttpOnly`, and `SameSite` flags. | V3.4.1 (Cookie Security) | Session Management Cheat Sheet |
| 9 | **TR-11:** Unlogged payroll runs | All sensitive financial transactions (like payroll runs) must generate an immutable, time-stamped audit log including the user ID. | V7.3.1 (Audit Logging) | Transaction Authorization Cheat Sheet |
| 10 | **TR-28:** Malicious CI/CD PRs | The CI/CD pipeline must require manual approval for external PRs and use a secure secrets manager (no hardcoded secrets). | V14.2.1 (Configuration) | DevSecOps Guideline |

## 3. Team Security Checklists

### Python Backend Team
- [ ] Validate and sanitize all incoming API request parameters.
- [ ] Enforce authorization checks on every endpoint (verify data ownership, not just login status).
- [ ] Verify JWT signatures and expiration on every request.
- [ ] Hash all stored passwords using Argon2id or bcrypt.
- [ ] Do not log sensitive data (passwords, tokens, PII, salary details).
- [ ] Implement rate limiting on heavy endpoints (e.g., concurrent PDF generation).

### Full Stack Team (Next.js Portal)
- [ ] Ensure all session cookies have `HttpOnly`, `Secure`, and `SameSite=Strict` flags.
- [ ] Contextually output-encode all user-supplied data to prevent XSS.
- [ ] Implement generic error messages for authentication failures (e.g., "Invalid credentials").
- [ ] Do not store sensitive tokens (like JWTs) in LocalStorage.
- [ ] Enforce account lockout or delay mechanisms on the login form.

### AI / ML Team
- [ ] Treat all LLM outputs as untrusted data.
- [ ] Do not pass raw API keys or backend system prompts in the user-accessible context.
- [ ] Implement input filtering to block known prompt injection keywords.
- [ ] Limit the maximum length of user prompts to prevent DoS via token exhaustion.
- [ ] Ensure the AI service cannot directly query the PostgreSQL database without going through the authorized Backend API.

### Data & DB Team
- [ ] Use parameterized queries (or ORM equivalents) for all database interactions to prevent SQL Injection.
- [ ] Encrypt all database backups and store them securely.
- [ ] Restrict Redis access to the local internal network only and require authentication.
- [ ] Ensure financial and system audit tables are append-only and tightly access-controlled.

### DevOps & Cloud Team
- [ ] Store all API keys, DB credentials, and JWT secrets in a dedicated Secrets Manager (e.g., HashiCorp Vault, AWS Secrets Manager).
- [ ] Enforce TLS 1.2+ for all external and internal network traffic.
- [ ] Implement WAF and rate limiting at the Reverse Proxy layer.
- [ ] Require mandatory code review and passing status checks before merging to `main`.
- [ ] Run automated SAST (Static Application Security Testing) and dependency scanning in the CI/CD pipeline.

## 4. Definition of Secure Done
Before a feature or pull request can be merged into the production branch, the following criteria must be met:
1. **Code Review:** The code has been reviewed and approved by at least one other developer.
2. **No Secrets:** No credentials, tokens, or API keys are hardcoded in the source code.
3. **Auth Verified:** All new API endpoints have both authentication (who are you?) and authorization (can you access this specific data?) explicitly enforced.
4. **Dependencies Checked:** No new libraries with known Critical/High CVEs have been introduced.
5. **Tests Pass:** Automated security scans and unit tests pass successfully in the pipeline.
