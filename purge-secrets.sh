#!/bin/bash
# Purge secrets from Git history using git-filter-repo

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧹 Purge Secrets from Git History"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if git-filter-repo is installed
if ! command -v git-filter-repo &> /dev/null; then
    echo "❌ git-filter-repo not found. Installing..."
    brew install git-filter-repo
    echo "✅ git-filter-repo installed"
else
    echo "✅ git-filter-repo already installed"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  WARNING: This will rewrite Git history!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This script will:"
echo "  • Rewrite all commits in Git history"
echo "  • Change all commit hashes"
echo "  • Remove secrets found by Gitleaks"
echo ""
echo "Before proceeding:"
echo "  ✅ Make sure you have a backup of your repo"
echo "  ✅ Coordinate with team members (if shared repo)"
echo "  ✅ Review the Gitleaks report to know what will be removed"
echo ""

# Check if there's a gitleaks report
LATEST_REPORT=$(ls -t reports/gitleaks-report-*.json 2>/dev/null | head -1)

if [ -z "$LATEST_REPORT" ]; then
    echo "❌ No Gitleaks report found!"
    echo "   Run ./scan-secrets.sh first to identify secrets"
    exit 1
fi

echo "📊 Using report: $LATEST_REPORT"
echo ""

# Extract secrets to replace
echo "🔍 Extracting secrets from report..."
mkdir -p .git-filter-repo

# Create expressions file for git-filter-repo
EXPRESSIONS_FILE=".git-filter-repo/expressions.txt"
> "$EXPRESSIONS_FILE"

# Parse JSON report and extract secrets
jq -r '.[] | .Secret' "$LATEST_REPORT" 2>/dev/null | while read -r secret; do
    if [ -n "$secret" ]; then
        # Escape special regex characters
        escaped_secret=$(echo "$secret" | sed 's/[]\/$*.^[]/\\&/g')
        echo "regex:$escaped_secret==>***REMOVED***" >> "$EXPRESSIONS_FILE"
    fi
done

SECRET_COUNT=$(wc -l < "$EXPRESSIONS_FILE" | tr -d ' ')

if [ "$SECRET_COUNT" -eq 0 ]; then
    echo "❌ No secrets found in report to purge"
    exit 1
fi

echo "✅ Found $SECRET_COUNT secret(s) to purge"
echo ""

# Show what will be replaced
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Secrets that will be replaced with '***REMOVED***':"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
jq -r '.[] | "  • \(.RuleID): \(.Secret[0:20])..."' "$LATEST_REPORT" 2>/dev/null
echo ""

# Confirm before proceeding
read -p "⚠️  Proceed with purging? This CANNOT be undone! (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Aborted"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Creating backup..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create backup
BACKUP_DIR="../dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
echo "Creating backup at: $BACKUP_DIR"
cp -r . "$BACKUP_DIR"
echo "✅ Backup created"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧹 Purging secrets from Git history..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Run git-filter-repo to replace secrets
git-filter-repo --replace-text "$EXPRESSIONS_FILE" --force

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Secrets purged from Git history!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Verify secrets are gone:"
echo "   ./scan-secrets.sh"
echo ""
echo "2. Re-add your remote (git-filter-repo removes it for safety):"
echo "   git remote add origin git@github.com:Kimeiga/dotfiles.git"
echo ""
echo "3. Force push to remote (⚠️  WARNING: This will rewrite remote history!):"
echo "   git push --force --all origin"
echo "   git push --force --tags origin"
echo ""
echo "4. Notify team members to re-clone the repo (if shared)"
echo ""
echo "💾 Backup saved at: $BACKUP_DIR"
echo ""

