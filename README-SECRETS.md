# 🔐 Secrets Management with SOPS

This dotfiles repo uses [SOPS](https://github.com/getsops/sops) to manage secrets securely.

## Why SOPS?

- ✅ **Safe to commit** - Secrets are encrypted in the repo
- ✅ **Easy to use** - Simple CLI interface
- ✅ **Team-friendly** - Multiple people can decrypt with their own keys
- ✅ **Flexible** - Supports age, GPG, AWS KMS, Azure Key Vault, etc.
- ✅ **Git-friendly** - Only encrypted values change, keys stay visible for diffs

## 🚀 Quick Setup

### 1. Install SOPS and age

```bash
brew install sops age
```

### 2. Generate your age key (one-time setup)

```bash
# Generate a new age key pair
age-keygen -o ~/.config/sops/age/keys.txt

# View your public key (you'll need this)
grep "# public key:" ~/.config/sops/age/keys.txt
```

**Important:** Save your private key (`~/.config/sops/age/keys.txt`) securely!
- Back it up to 1Password or another password manager
- Never commit it to git
- You'll need it to decrypt secrets on new machines

### 3. Update `.sops.yaml` with your public key

Replace the placeholder in `.sops.yaml` with your actual public key:

```yaml
creation_rules:
  - path_regex: secrets/.*\.env$
    age: >-
      age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      #     ↑ Replace this with your actual public key
```

### 4. Create your secrets file

```bash
# Create unencrypted secrets file
cat > secrets/doordash.env << 'EOF'
# DoorDash Artifactory credentials
ARTIFACTORY_USERNAME=hakan.alpay@doordash.com
ARTIFACTORY_PASSWORD=***REMOVED***
EOF

# Encrypt it with SOPS
sops --encrypt --in-place secrets/doordash.env

# Now it's safe to commit!
git add secrets/doordash.env
git commit -m "Add encrypted DoorDash secrets"
```

### 5. Update your `.zshrc` to load secrets

Add this to your `.zshrc`:

```bash
# Load encrypted secrets (SOPS will decrypt automatically)
if command -v sops &> /dev/null && [ -f ~/dotfiles/secrets/doordash.env ]; then
  eval "$(sops --decrypt ~/dotfiles/secrets/doordash.env | grep -v '^#' | sed 's/^/export /')"
fi
```

## 📝 Daily Usage

### View secrets

```bash
# View decrypted content
sops secrets/doordash.env

# Or just decrypt to stdout
sops --decrypt secrets/doordash.env
```

### Edit secrets

```bash
# SOPS will decrypt, open in $EDITOR, then re-encrypt on save
sops secrets/doordash.env
```

### Add new secrets

```bash
# Create new file
echo "NEW_SECRET=value" > secrets/new-service.env

# Encrypt it
sops --encrypt --in-place secrets/new-service.env

# Commit it
git add secrets/new-service.env
git commit -m "Add new service secrets"
```

## 🔄 Setting up on a new machine

1. Clone your dotfiles repo
2. Install SOPS and age: `brew install sops age`
3. Copy your age private key to `~/.config/sops/age/keys.txt`
4. Secrets will automatically decrypt when you source `.zshrc`!

## 🤝 Sharing with team members

If you want to share these dotfiles with teammates:

1. Get their age public key
2. Add it to `.sops.yaml`:

```yaml
creation_rules:
  - path_regex: secrets/.*\.env$
    age: >-
      age1your_key_here,
      age1teammate_key_here
```

3. Re-encrypt all secrets with both keys:

```bash
sops updatekeys secrets/doordash.env
```

Now both you and your teammate can decrypt!

## 🛡️ Security Best Practices

- ✅ **DO** commit encrypted `.env` files to git
- ✅ **DO** back up your age private key securely (1Password, etc.)
- ✅ **DO** use different keys for personal vs work secrets
- ❌ **DON'T** commit your age private key
- ❌ **DON'T** commit unencrypted `.env` files
- ❌ **DON'T** share your private key in Slack/email

## 🔧 Troubleshooting

### "no key could be found to decrypt the data"

Your age private key is missing or in the wrong location.

**Fix:**
```bash
# Make sure your key is here:
ls -la ~/.config/sops/age/keys.txt

# If missing, restore from backup or regenerate
```

### "failed to decrypt"

The file was encrypted with a different key.

**Fix:**
```bash
# If you have the old key, decrypt and re-encrypt:
sops --decrypt secrets/file.env > /tmp/file.env
sops --encrypt /tmp/file.env > secrets/file.env
rm /tmp/file.env
```

## 📚 Alternative: Using direnv (optional)

For automatic secret loading per directory:

```bash
brew install direnv

# Add to .zshrc (already done if using our config)
eval "$(direnv hook zsh)"

# Create .envrc in project directory
echo 'eval "$(sops --decrypt ~/dotfiles/secrets/doordash.env)"' > .envrc

# Allow it
direnv allow .
```

Now secrets load automatically when you `cd` into the directory!

## 🔗 Resources

- [SOPS Documentation](https://github.com/getsops/sops)
- [age Documentation](https://github.com/FiloSottile/age)
- [SOPS Tutorial](https://dev.to/stack-labs/manage-your-secrets-in-git-with-sops-common-operations-118g)

