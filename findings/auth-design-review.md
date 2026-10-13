# Authentication & Role Design Review

## 1. Python Team's Draft Design (Summary)
*   **Sign-in:** Users log in with email and password. Passwords stored using SHA-256. Errors specify whether the user was not found or the password was wrong.
*   **Tokens & Refresh:** A JWT access token is issued valid for 24 hours. No refresh tokens are used.
*   **Logout:** The client application deletes the JWT from local storage.
*   **Password Reset:** A link is emailed containing the User ID to reset the password.
*   **Roles:** Hardcoded 'Admin' and 'User' roles in the database.
*   **Rate Limiting / MFA:** Not currently included in the scope.

## 2. Security Review & Decisions (Checklist)

| Topic | Draft Design | Security Concern (What & Why) | Suggested Change | Python Team Decision |
| :--- | :--- | :--- | :--- | :--- |
| **Password Hashing** | SHA-256 (Fast hash) | SHA-256 is too fast and vulnerable to offline cracking/rainbow tables. | Use a slow, salted algorithm like Argon2id or bcrypt. | **Accepted.** Will implement bcrypt. |
| **Rate Limiting** | None | Attackers can brute-force passwords without restriction. | Lockout account for 15 mins after 5 failed attempts. | **Accepted.** Will add rate limiting via Redis. |
| **Token Lifetime** | 24-hour Access Token | If stolen, an attacker has 24 hours of access. | Shorten Access Token to 15 mins. Implement HTTP-only secure Refresh Tokens (7 days). | **Accepted.** |
| **Logout** | Client-side deletion | Token remains valid on the server if intercepted before logout. | Implement a server-side blocklist for revoked tokens. | **Accepted.** |
| **Error Messages** | Specific errors | Allows attackers to enumerate valid email addresses. | Use a generic error: "Invalid email or password." | **Accepted.** |
| **Password Reset** | Static User ID link | Predictable and never expires; attackers can forge reset links. | Use secure, single-use, time-bound (15 min) randomized tokens. | **Accepted.** |
| **Roles** | Admin / User | May violate least privilege if 'Admin' has too much power. | Add granular permissions mapped to roles later. | **Risk Accepted for now.** Will stick to 2 roles for MVP, but design DB to support granular permissions later. |
| **MFA Readiness** | None | Cannot add 2FA later without a database migration. | Add an empty `mfa_secret` and `mfa_enabled` column now to save time later. | **Accepted.** |

## 3. Risk Register Updates (From Task 1)
*   **New Risk:** Account Takeover via Brute Force. **Mitigation:** Account lockout policy agreed (5 attempts / 15 mins).
*   **New Risk:** Session Hijacking via Stolen JWT. **Mitigation:** Short-lived access tokens (15m) + Server-side blocklist for logout.
*   **Risk Status:** These mitigations reduce the overall system risk score.

## 4. Full Stack Team Communication
*   **Action:** Shared this document with the Full Stack team so they can build generic login error messages, handle 15-minute token refreshes in the background, and build the 5-attempt lockout UI warning.
