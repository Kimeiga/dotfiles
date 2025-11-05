#!/bin/bash
# Scan Git history for secrets using Gitleaks

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Scanning Git History for Secrets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if gitleaks is installed
if ! command -v gitleaks &> /dev/null; then
    echo "❌ Gitleaks not found. Installing..."
    brew install gitleaks
    echo "✅ Gitleaks installed"
else
    echo "✅ Gitleaks already installed ($(gitleaks version))"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔎 Scanning entire Git history..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create reports directory
mkdir -p reports

# Run gitleaks scan
REPORT_FILE="reports/gitleaks-report-$(date +%Y%m%d-%H%M%S).json"
REPORT_TXT="reports/gitleaks-report-$(date +%Y%m%d-%H%M%S).txt"

echo "Scanning... (this may take a minute)"
echo ""

if gitleaks detect --source . --report-path "$REPORT_FILE" --report-format json --verbose 2>&1 | tee "$REPORT_TXT"; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ No secrets found in Git history!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Your repository is clean and safe to make public! 🎉"
    echo ""
else
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  SECRETS FOUND IN GIT HISTORY!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📊 Report saved to:"
    echo "   - JSON: $REPORT_FILE"
    echo "   - Text: $REPORT_TXT"
    echo ""
    
    # Parse and display summary
    if [ -f "$REPORT_FILE" ]; then
        SECRET_COUNT=$(jq '. | length' "$REPORT_FILE" 2>/dev/null || echo "unknown")
        echo "🔴 Found $SECRET_COUNT secret(s) in Git history"
        echo ""
        
        # Show summary of findings
        echo "Summary of findings:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        jq -r '.[] | "  • \(.RuleID) in \(.File) (commit: \(.Commit)[0:7])"' "$REPORT_FILE" 2>/dev/null || cat "$REPORT_TXT"
        echo ""
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🧹 Next Steps:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1. Review the report: cat $REPORT_TXT"
    echo "2. Run the purge script: ./purge-secrets.sh"
    echo "3. Re-scan to verify: ./scan-secrets.sh"
    echo ""
    echo "⚠️  WARNING: Purging secrets will rewrite Git history!"
    echo "   - All commit hashes will change"
    echo "   - Requires force push if already pushed to remote"
    echo "   - Coordinate with team members if shared repo"
    echo ""
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Scan complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

