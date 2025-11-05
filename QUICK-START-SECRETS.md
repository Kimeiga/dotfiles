# 🚀 Quick Start: Making Your Dotfiles Public-Safe

## TL;DR - 3 Commands to Secure Your Secrets

```bash
# 1. Setup SOPS and generate encryption key
./setup-secrets.sh

# 2. Copy your public key and update .sops.yaml (shown in output above)
# Edit .sops.yaml and replace the placeholder with your actual key

# 3. Migrate secrets from .zshrc to encrypted files
./migrate-secrets.sh
```

That's it! Your secrets are now encrypted and safe to push to a public GitHub repo.

---

## What This Does

### Before (❌ NOT SAFE):
```bash
# In your .zshrc - PLAINTEXT SECRETS!
export ARTIFACTORY_PASSWORD=***REMOVED***
```

### After (✅ SAFE):
```bash
# In secrets/doordash.env - ENCRYPTED!
{
    "data": "ENC[AES256_GCM,data:8x7vQ...,tag:abc123...]",
    "sops": {
        "kms": [],
        "gcp_kms": [],
        "azure_kv": [],
        "age": [...]
    }
}
```

---

## Step-by-Step Guide

### Step 1: Run Setup Script

```bash
./setup-secrets.sh
```

This will:
- ✅ Install SOPS (if not installed)
- ✅ Install age (if not installed)
- ✅ Generate your encryption key pair
- ✅ Show you your public key

**Output will look like:**
```
Your public key:
# public key: ***REMOVED***
```

**⚠️ IMPORTANT:** Copy this public key!

### Step 2: Update .sops.yaml

Edit `.sops.yaml` and replace the placeholder:

```yaml
creation_rules:
  - path_regex: secrets/.*\.env$
    age: >-
      ***REMOVED***
      #     ↑ Paste your actual public key here
```

### Step 3: Migrate Your Secrets

```bash
./migrate-secrets.sh
```

This will:
- ✅ Extract secrets from your .zshrc
- ✅ Create `secrets/doordash.env` with your secrets
- ✅ Encrypt it with SOPS
- ✅ Generate a snippet to add to your .zshrc

### Step 4: Update Your .zshrc

The migration script creates `secrets/zshrc-snippet.txt`. 

**Replace this section in `zsh/.zshrc`:**

```bash
# OLD - Remove this:
# Artifactory (DoorDash)
export ARTIFACTORY_USERNAME=hakan.alpay@doordash.com
export ARTIFACTORY_PASSWORD=***REMOVED***
export artifactoryUser=${ARTIFACTORY_USERNAME}
export artifactoryPassword=${ARTIFACTORY_PASSWORD}
export ARTIFACTORY_URL=https://${ARTIFACTORY_USERNAME/@/%40}:${ARTIFACTORY_PASSWORD}@ddartifacts.jfrog.io/ddartifacts/api/pypi/pypi-local/simple/
export PIP_EXTRA_INDEX_URL=${ARTIFACTORY_URL}
```

**With the content from `secrets/zshrc-snippet.txt`**

### Step 5: Test It Works

```bash
# Reload your shell
source ~/.zshrc

# Check that secrets loaded
echo $ARTIFACTORY_USERNAME
# Should output: hakan.alpay@doordash.com

echo $ARTIFACTORY_PASSWORD
# Should output: ***REMOVED***
```

### Step 6: Commit and Push!

```bash
# Add encrypted secrets
git add secrets/doordash.env .sops.yaml

# Commit
git commit -m "Add encrypted secrets"

# Push to public repo - SAFE! 🎉
git push origin master
```

---

## 🎉 You're Done!

Your dotfiles are now safe to share publicly on GitHub!

- ✅ Secrets are encrypted with your personal key
- ✅ Only you (and people you share your key with) can decrypt
- ✅ Safe to commit and push to public repos
- ✅ Easy to set up on new machines (just copy your age key)

---

## 📚 Need More Info?

See `README-SECRETS.md` for:
- Detailed documentation
- How to edit secrets
- How to share with teammates
- Troubleshooting
- Security best practices

---

## 🆘 Quick Troubleshooting

### "sops: command not found"
```bash
brew install sops age
```

### "no key could be found to decrypt"
Your age private key is missing. It should be at:
```bash
~/.config/sops/age/keys.txt
```

Restore it from your backup (1Password, etc.)

### Secrets not loading in .zshrc
Make sure SOPS is installed:
```bash
which sops
# Should output: /opt/homebrew/bin/sops (or similar)
```

---

## 🔐 Security Checklist

Before pushing to public GitHub:

- [ ] Ran `./setup-secrets.sh`
- [ ] Updated `.sops.yaml` with your public key
- [ ] Ran `./migrate-secrets.sh`
- [ ] Updated `.zshrc` to load from encrypted files
- [ ] Tested that secrets load: `source ~/.zshrc && echo $ARTIFACTORY_USERNAME`
- [ ] Removed plaintext secrets from `.zshrc`
- [ ] Committed encrypted `secrets/doordash.env`
- [ ] Verified `.gitignore` blocks `*.env` files (except in `secrets/`)
- [ ] Backed up your age private key to 1Password

✅ All checked? You're ready to push! 🚀

