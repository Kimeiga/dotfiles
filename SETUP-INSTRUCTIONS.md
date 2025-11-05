# 🚀 Setup Instructions - Complete SOPS Configuration

## ✅ What's Already Done

1. ✅ **SOPS and age installed**
2. ✅ **Age encryption key generated** at `~/.config/sops/age/keys.txt`
3. ✅ **`.sops.yaml` configured** with your public key
4. ✅ **`.zshrc` updated** to load secrets from SOPS
5. ✅ **Git history purged** of all secrets
6. ✅ **Backup created** at `../dotfiles-backup-20251104-203817`

---

## 🔑 Your Age Public Key

```
age18uksntc4lz58z0tkf9vh28m7pazycnwty3dgs0r8p09vg8j8mdwqhhqvau
```

**⚠️ IMPORTANT:** Back up your private key!
```bash
# Copy to 1Password or another password manager
cat ~/.config/sops/age/keys.txt
```

---

## 📝 What You Need to Do

### Step 1: Rotate Your Artifactory Password

**CRITICAL:** Your old Artifactory password was exposed in Git history!

1. Go to DoorDash Artifactory settings
2. Generate a NEW API token/password
3. Save it somewhere temporarily (you'll need it in Step 2)

### Step 2: Create Encrypted Secrets Files

Run the interactive script:

```bash
./create-encrypted-secrets.sh
```

This will prompt you for:
1. **NEW Artifactory password** (from Step 1)
2. **Refact.ai API key** (optional - press Enter to skip)
3. **OpenWeatherMap API key** (optional - press Enter to skip)

The script will create encrypted files:
- `secrets/doordash.env` (encrypted)
- `secrets/refactai.env` (encrypted, if provided)
- `secrets/openweathermap.env` (encrypted, if provided)

### Step 3: Verify Encryption Worked

```bash
# Should show encrypted data (JSON with "sops" metadata)
cat secrets/doordash.env

# Should show your actual password
sops --decrypt secrets/doordash.env
```

### Step 4: Test Loading Secrets

```bash
# Reload your shell
source ~/.zshrc

# Verify secrets loaded
echo $ARTIFACTORY_USERNAME  # Should show: hakan.alpay@doordash.com
echo $ARTIFACTORY_PASSWORD  # Should show: your NEW password
echo $REFACTAI_API_KEY      # Should show: your API key (if you added it)
```

### Step 5: Update VSCode Settings (Optional)

If you added a Refact.ai API key, update your VSCode settings:

```bash
# Edit vscode-settings/settings.json
# Change line 71 from:
"refactai.apiKey": "***REMOVED***",

# To load from environment:
"refactai.apiKey": "${env:REFACTAI_API_KEY}",
```

Or manually paste your Refact.ai key there (it won't be committed since it's in .gitignore).

### Step 6: Commit Encrypted Secrets

```bash
# Add encrypted secrets
git add secrets/doordash.env secrets/refactai.env secrets/openweathermap.env .sops.yaml zsh/.zshrc

# Commit
git commit -m "feat: migrate secrets to SOPS encryption

- Encrypted Artifactory credentials with SOPS
- Encrypted Refact.ai API key (optional)
- Encrypted OpenWeatherMap API key (optional)
- Updated .zshrc to load from encrypted files
- All secrets now safe for public repo"

# Check status
git status
```

### Step 7: Force Push to GitHub

**⚠️ WARNING:** This will rewrite remote history!

```bash
# Force push all branches
git push --force --all origin

# Force push tags
git push --force --tags origin
```

### Step 8: Make Repo Public! 🎉

Your repo is now safe to make public on GitHub!

1. Go to https://github.com/Kimeiga/dotfiles/settings
2. Scroll to "Danger Zone"
3. Click "Change visibility" → "Make public"

---

## 🔍 Verification Checklist

Before making repo public:

- [ ] Rotated Artifactory password
- [ ] Created encrypted secrets: `./create-encrypted-secrets.sh`
- [ ] Verified encryption: `cat secrets/doordash.env` shows encrypted data
- [ ] Tested decryption: `sops --decrypt secrets/doordash.env` works
- [ ] Tested loading: `source ~/.zshrc && echo $ARTIFACTORY_PASSWORD` shows password
- [ ] Committed encrypted secrets
- [ ] Force pushed to GitHub
- [ ] Backed up age private key to 1Password
- [ ] Verified no plaintext secrets in repo: `git log -S "your-password" --all`

---

## 🆘 Troubleshooting

### "sops: failed to decrypt"

Your age private key is missing or wrong.

**Fix:**
```bash
# Check if key exists
ls -la ~/.config/sops/age/keys.txt

# If missing, restore from backup
cp ../dotfiles-backup-20251104-203817/.config/sops/age/keys.txt ~/.config/sops/age/keys.txt
```

### "command not found: sops"

SOPS not installed.

**Fix:**
```bash
brew install sops age
```

### Secrets not loading in shell

**Fix:**
```bash
# Make sure SOPS is in PATH
which sops

# Check if secrets file exists
ls -la ~/dotfiles/secrets/doordash.env

# Try manual decrypt
sops --decrypt ~/dotfiles/secrets/doordash.env
```

### VSCode Refact.ai not working

VSCode can't read environment variables set in .zshrc.

**Fix:**
```bash
# Option 1: Manually paste API key in settings.json
# Edit vscode-settings/settings.json line 71

# Option 2: Launch VSCode from terminal (inherits env vars)
code .
```

---

## 📚 Files Created

### Encrypted Secrets (safe to commit)
- `secrets/doordash.env` - Artifactory credentials
- `secrets/refactai.env` - Refact.ai API key
- `secrets/openweathermap.env` - OpenWeatherMap API key

### Templates (safe to commit)
- `secrets/doordash.env.template`
- `secrets/refactai.env.template`
- `secrets/openweathermap.env.template`

### Configuration
- `.sops.yaml` - SOPS encryption rules
- `zsh/.zshrc` - Updated to load from SOPS

### Scripts
- `setup-secrets.sh` - Install SOPS and generate keys
- `create-encrypted-secrets.sh` - Interactive secrets creation
- `scan-secrets.sh` - Scan Git history for secrets
- `purge-secrets.sh` - Remove secrets from Git history

### Documentation
- `README-SECRETS.md` - Complete SOPS guide
- `QUICK-START-SECRETS.md` - Quick start guide
- `SCAN-AND-PURGE-SECRETS.md` - Secret scanning guide
- `SETUP-INSTRUCTIONS.md` - This file

---

## 🎯 Summary

**What was the problem?**
- Your Artifactory password was committed in Git history (commits `d99d75e`, `5187cec`, `63d9c18`)
- Making the repo public would expose your credentials

**What did we do?**
1. ✅ Scanned Git history and found secrets
2. ✅ Purged secrets from all 614 commits with git-filter-repo
3. ✅ Set up SOPS encryption with age
4. ✅ Updated .zshrc to load secrets from encrypted files
5. ✅ Created helper scripts for easy setup

**What's next?**
1. Rotate your Artifactory password
2. Run `./create-encrypted-secrets.sh`
3. Commit encrypted secrets
4. Force push to GitHub
5. Make repo public! 🎉

---

## 🔗 Resources

- [SOPS Documentation](https://github.com/getsops/sops)
- [age Documentation](https://github.com/FiloSottile/age)
- [GitHub: Removing Sensitive Data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)

---

**Need help?** Check `README-SECRETS.md` for detailed documentation!

