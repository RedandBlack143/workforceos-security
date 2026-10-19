# Task 1: Data Classification Summary

## The "Think for yourself" Question
**Is a name by itself personal data? A name plus department? Decide where the line is and explain.**
A name by itself (e.g., "John Smith") is generally *not* personal data because there are thousands of people with that name; it lacks the context to uniquely identify a single individual. However, a name plus a department (e.g., "John Smith in HR") *is* personal data. The "line" is crossed the moment combined data points allow you to single out a specific human being from a crowd.

## Classification Summary

| Sensitivity Level | Column Count |
| :--- | :--- |
| **Internal** | 103 |
| **Restricted** | 37 |
| **Confidential** | 29 |
| **Public** | 0 |

## Hardest Columns Reasoning (Top 5 Examples)
1. **`work_email` (Internal):** Contains a personal name, but it is a corporate asset required for daily operations. Wide internal access is needed.
2. **`commute_distance_km` (Confidential):** Exact distance metrics can be used to infer home location proximity or socio-economic status.
3. **`performance_rating` (Confidential):** Highly sensitive HR data that impacts salary and career trajectories, but does not contain direct financial numbers.
4. **`reason` [Leave Requests] (Confidential):** Leave reasons often reveal highly sensitive medical situations, family emergencies, or personal struggles.
5. **`password_policy_note` (Restricted):** While not the password itself, security metadata can provide attackers with clues on how to bypass authentication.
