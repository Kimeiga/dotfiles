# 🔍 Scanning and Purging Secrets from Git History

Before making your dotfiles repo public, you should scan the entire Git history for any secrets that may have been committed in the past.

---

## 🚀 Quick Start

### Step 1: Scan for Secrets

```bash
./scan-secrets.sh
```

This will:
- ✅ Install Gitleaks (if not installed)
- ✅ Scan your entire Git history
- ✅ Generate a detailed report of any secrets found
- ✅ Tell you if your repo is clean or needs purging

### Step 2: Purge Secrets (if found)

```bash
./purge-secrets.sh
```

This will:
- ✅ Install git-filter-repo (if not installed)
- ✅ Create a backup of your repo
- ✅ Remove all secrets from Git history
- ✅ Rewrite commit history (all hashes will change)

### Step 3: Verify

```bash
./scan-secrets.sh
```

Run the scan again to verify all secrets are gone!

---

## 🔧 Tools Used

### 1. **Gitleaks** (Secret Scanner)

**Why Gitleaks?**
- ✅ Most popular open-source secret scanner
- ✅ Fast and accurate
- ✅ Low false positives
- ✅ Scans entire Git history
- ✅ Actively maintained

**What it detects:**
- API keys (AWS, Google Cloud, Azure, etc.)
- Passwords and credentials
- Private keys (SSH, PGP, etc.)
- OAuth tokens
- Database connection strings
- And 100+ other secret types

### 2. **git-filter-repo** (History Rewriter)

**Why git-filter-repo?**
- ✅ Official replacement for `git filter-branch`
- ✅ 10-50x faster than `git filter-branch`
- ✅ Safer (prevents common mistakes)
- ✅ Recommended by GitHub
- ✅ More powerful than BFG Repo-Cleaner

**What it does:**
- Rewrites Git history to remove secrets
- Replaces secrets with `***REMOVED***`
- Preserves commit messages and authorship
- Updates all references automatically

---

## 📊 Understanding the Scan Results

### ✅ Clean Repo (No Secrets Found)

```
✅ No secrets found in Git history!

Your repository is clean and safe to make public! 🎉
```

**You're good to go!** Proceed with:
1. Setting up SOPS encryption (`./setup-secrets.sh`)
2. Migrating current secrets (`./migrate-secrets.sh`)
3. Pushing to public GitHub

### ⚠️ Secrets Found

```
⚠️  SECRETS FOUND IN GIT HISTORY!

🔴 Found 5 secret(s) in Git history

Summary of findings:
  • generic-api-key in zsh/.zshrc (commit: a1b2c3d)
  • aws-access-token in old-config.sh (commit: e4f5g6h)
  ...
```

**Action required!** You need to:
1. Review the report: `cat reports/gitleaks-report-*.txt`
2. Run the purge script: `./purge-secrets.sh`
3. Re-scan to verify: `./scan-secrets.sh`

---

## 📝 Detailed Workflow

### Scenario 1: Clean History (No Secrets)

```bash
# 1. Scan
./scan-secrets.sh
# Output: ✅ No secrets found!

# 2. Setup SOPS encryption for current secrets
./setup-secrets.sh

# 3. Migrate current secrets
./migrate-secrets.sh

# 4. Push to public GitHub
git push origin master
```

### Scenario 2: Secrets Found in History

```bash
# 1. Scan
./scan-secrets.sh
# Output: ⚠️ Found 5 secrets!

# 2. Review the report
cat reports/gitleaks-report-*.txt

# 3. Purge secrets from history
./purge-secrets.sh
# ⚠️ This will rewrite Git history!

# 4. Verify they're gone
./scan-secrets.sh
# Output: ✅ No secrets found!

# 5. Re-add remote (git-filter-repo removes it for safety)
git remote add origin git@github.com:Kimeiga/dotfiles.git

# 6. Force push (⚠️ rewrites remote history!)
git push --force --all origin
git push --force --tags origin

# 7. Setup SOPS for current secrets
./setup-secrets.sh
./migrate-secrets.sh
```

---

## ⚠️ Important Warnings

### Before Purging Secrets

1. **Backup your repo**
   - The purge script creates a backup automatically
   - But you should also have your own backup!

2. **Coordinate with team members**
   - If this is a shared repo, notify everyone
   - They'll need to re-clone after you force push

3. **Understand the impact**
   - All commit hashes will change
   - Git history will be rewritten
   - Requires force push to remote
   - Cannot be undone (except from backup)

### After Purging Secrets

1. **Re-add your remote**
   ```bash
   git remote add origin git@github.com:Kimeiga/dotfiles.git
   ```

2. **Force push to remote**
   ```bash
   git push --force --all origin
   git push --force --tags origin
   ```

3. **Invalidate old secrets**
   - Even though they're removed from Git history, they may still be valid
   - Rotate any API keys, passwords, or tokens that were exposed
   - Update them in your SOPS-encrypted files

4. **Team members must re-clone**
   ```bash
   # Don't try to pull - it will fail!
   cd ..
   rm -rf dotfiles
   git clone git@github.com:Kimeiga/dotfiles.git
   ```

---

## 🔍 What Gets Scanned?

Gitleaks scans for:

### Common Secrets
- ✅ API keys (AWS, Google Cloud, Azure, GitHub, etc.)
- ✅ Access tokens (OAuth, JWT, etc.)
- ✅ Passwords and credentials
- ✅ Private keys (SSH, PGP, RSA, etc.)
- ✅ Database connection strings
- ✅ Slack tokens
- ✅ Stripe keys
- ✅ SendGrid keys
- ✅ And 100+ more patterns

### Your Specific Secrets
Based on your `.zshrc`, these will be detected:
- ✅ `ARTIFACTORY_PASSWORD` (base64-encoded token)
- ✅ `ARTIFACTORY_USERNAME` (email address)
- ✅ Any other API keys or tokens

---

## 📂 Report Files

After scanning, you'll find reports in the `reports/` directory:

```
reports/
├── gitleaks-report-20241105-143022.json  # Machine-readable
└── gitleaks-report-20241105-143022.txt   # Human-readable
```

### JSON Report Structure

```json
[
  {
    "Description": "Identified a Generic API Key",
    "StartLine": 145,
    "EndLine": 145,
    "StartColumn": 28,
    "EndColumn": 88,
    "Match": "ARTIFACTORY_PASSWORD=***REMOVED***",
    "Secret": "***REMOVED***",
    "File": "zsh/.zshrc",
    "Commit": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0",
    "RuleID": "generic-api-key"
  }
]
```

---

## 🛠️ Troubleshooting

### "gitleaks: command not found"

```bash
brew install gitleaks
```

### "git-filter-repo: command not found"

```bash
brew install git-filter-repo
```

### "No secrets found but I know there are some"

Gitleaks might not detect custom secret formats. You can:

1. **Add custom rules** - Create `.gitleaks.toml`:
   ```toml
   [[rules]]
   id = "custom-secret"
   description = "Custom secret pattern"
   regex = '''your-pattern-here'''
   ```

2. **Use TruffleHog** (alternative scanner):
   ```bash
   brew install trufflesecurity/trufflehog/trufflehog
   trufflehog git file://. --json > reports/trufflehog-report.json
   ```

### "Purge script failed"

1. Check the backup was created: `ls -la ../dotfiles-backup-*`
2. Restore from backup if needed: `cp -r ../dotfiles-backup-* .`
3. Review the error message
4. Try manual purging (see below)

### Manual Purging (Advanced)

If the script fails, you can manually purge specific secrets:

```bash
# Create expressions file
cat > expressions.txt << 'EOF'
regex:your-secret-here==>***REMOVED***
EOF

# Run git-filter-repo
git-filter-repo --replace-text expressions.txt --force

# Re-add remote
git remote add origin git@github.com:Kimeiga/dotfiles.git
```

---

## 🔗 Resources

- [Gitleaks Documentation](https://github.com/gitleaks/gitleaks)
- [git-filter-repo Documentation](https://github.com/newren/git-filter-repo)
- [GitHub: Removing Sensitive Data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [TruffleHog (Alternative Scanner)](https://github.com/trufflesecurity/trufflehog)

---

## 📋 Checklist: Making Repo Public

Before pushing to public GitHub:

- [ ] Scanned Git history: `./scan-secrets.sh`
- [ ] Purged any secrets found: `./purge-secrets.sh`
- [ ] Verified secrets are gone: `./scan-secrets.sh` (should be clean)
- [ ] Set up SOPS encryption: `./setup-secrets.sh`
- [ ] Migrated current secrets: `./migrate-secrets.sh`
- [ ] Updated `.zshrc` to load from encrypted files
- [ ] Tested secrets load correctly: `source ~/.zshrc && echo $ARTIFACTORY_USERNAME`
- [ ] Committed encrypted secrets: `git add secrets/doordash.env`
- [ ] Backed up age private key to 1Password
- [ ] Removed plaintext secrets from `.zshrc`
- [ ] Final scan: `./scan-secrets.sh` (should be clean)

✅ All checked? You're ready to go public! 🚀

```bash
git push origin master
```

