#!/bin/bash
# Aegis-Shield: Unified Security Scan Script

mkdir -p findings/reports
echo "[*] Starting Security Scans..."

echo "[1/4] Running Secret Scanner (Gitleaks)..."
# Scans git history and workspace for hardcoded secrets
gitleaks detect --source . -v --report-path findings/reports/gitleaks-report.json || echo "  -> Gitleaks check complete."

echo "[2/4] Running Python Dependency Scanner (pip-audit)..."
# Scans requirements.txt for known CVEs
if [ -f "requirements.txt" ]; then
    pip-audit -r requirements.txt -f json -o findings/reports/pip-audit-report.json || echo "  -> pip-audit check complete."
else
    echo "  -> No requirements.txt found, skipping."
fi

echo "[3/4] Running JS Dependency Scanner (npm audit)..."
if [ -f "package.json" ]; then
    npm audit --json > findings/reports/npm-audit-report.json || echo "  -> npm audit check complete."
else
    echo "  -> No package.json found, skipping."
fi

echo "[4/4] Running OWASP ZAP (DAST)..."
# Runs ZAP against a local dev server (placeholder target: http://localhost:8080)
docker run --rm -v $(pwd)/findings/reports:/zap/wrk/:rw -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t http://localhost:8080 -J zap-report.json || echo "  -> ZAP scan completed."

echo "[*] All scans complete! Reports saved to findings/reports/"
