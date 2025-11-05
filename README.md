# dotfiles

> There's no place like ~/

Personal dotfiles for macOS/Linux with encrypted secrets management using SOPS.

![screenshot](https://i.imgur.com/TeOS6uh.png)

## ✨ Features

- 🚀 **Fast ZSH setup** with [Powerlevel10k](https://github.com/romkatv/powerlevel10k) (~120ms startup)
- 🔐 **Encrypted secrets** using [SOPS](https://github.com/mozilla/sops) (safe for public repos)
- 📦 **Version management** with [asdf](https://asdf-vm.com/) (Node, Python, Java)
- ☸️ **Kubernetes context** in prompt (DoorDash Teleport support)
- 🎨 **Minimal & clean** prompt design
- 🔧 **Optimized for DoorDash** development workflow

## 📁 What's Inside

```
 git        > git config and aliases
 nvim       > neovim config
 secrets    > encrypted API keys and credentials (SOPS)
 spells     > automation scripts
 zsh        > shell config with Zinit + Powerlevel10k
 ```

## 🚀 Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/Kimeiga/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Install stow (if not already installed)

```bash
# macOS
brew install stow

# Linux (Debian/Ubuntu)
sudo apt install stow

# Linux (Arch)
sudo pacman -S stow
```

### 3. Symlink dotfiles with stow

```bash
# Link ZSH config
stow zsh

# Link other configs as needed
stow git
stow nvim
stow tmux
# ... etc
```

**How stow works:** It creates symlinks in your home directory pointing to files in `~/dotfiles/`. For example, `stow zsh` creates `~/.zshrc` → `~/dotfiles/zsh/.zshrc`.

### 4. Set up secrets (optional)

If you want to use encrypted secrets:

```bash
# Install SOPS and age
./setup-secrets.sh

# Copy templates and fill in your values
cp secrets/doordash.env.template secrets/doordash.env
cp secrets/personal.env.template secrets/personal.env

# Edit with your actual secrets
vim secrets/doordash.env
vim secrets/personal.env

# Encrypt them
sops --encrypt --in-place secrets/doordash.env
sops --encrypt --in-place secrets/personal.env
```

### 5. Reload your shell

```bash
exec zsh
```

Done! 🎉

---

**Note:** If you prefer manual symlinks instead of stow, you can use:
```bash
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/.zprofile ~/.zprofile
ln -sf ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
```


## 🔐 Secrets Management

This repo uses [SOPS](https://github.com/mozilla/sops) with [age](https://github.com/FiloSottile/age) encryption to safely store secrets in a public repository.

### How it works

- Secrets are stored in `secrets/*.env` files
- Files are encrypted with SOPS using your age key
- Encrypted files are safe to commit to public repos
- Your private age key stays on your machine (never committed)

### File structure

```
secrets/
├── doordash.env           # Work secrets (Artifactory, etc.)
├── doordash.env.template  # Template for new users
├── personal.env           # Personal API keys
└── personal.env.template  # Template for new users
```

### Adding new secrets

**For work secrets:**
```bash
sops ~/dotfiles/secrets/doordash.env
# Add your secret, save, and exit
```

**For personal secrets:**
```bash
sops ~/dotfiles/secrets/personal.env
# Add your secret, save, and exit
```

SOPS automatically encrypts the file when you save!

### Setting up on a new machine

1. **Restore your age key** (from 1Password or backup):
   ```bash
   mkdir -p ~/.config/sops/age

   # Paste your entire age key backup (all 3 lines) into:
   vim ~/.config/sops/age/keys.txt

   # Should look like:
   # # created: 2025-11-04T20:41:24-05:00
   # # public key: age18uksntc4lz58z0tkf9vh28m7pazycnwty3dgs0r8p09vg8j8mdwqhhqvau
   # AGE-SECRET-KEY-1U6A2HUNGA933K9W59EP0LGEXWHZ6MC3S7VCSMKNPDGTJ450XL9PS534RA2

   # Set correct permissions
   chmod 600 ~/.config/sops/age/keys.txt
   ```

2. **Clone and link dotfiles** (see Quick Start above)

3. **Secrets will auto-load** when you start a new shell!

### Security notes

- ✅ Encrypted `.env` files are committed to git
- ❌ Your age private key (`~/.config/sops/age/keys.txt`) is NEVER committed
- ✅ Back up your age key to 1Password or another secure location
- ✅ Rotate secrets regularly (Artifactory tokens expire yearly)

## 🛠️ Tools & Scripts

- **`setup-secrets.sh`** - Install SOPS/age and generate encryption keys (one-time setup)
- **`scan-secrets.sh`** - Scan git history for accidentally committed secrets

## ⚡ Performance

ZSH startup time: **~120ms** (optimized with lazy loading)

Key optimizations:
- Powerlevel10k instant prompt
- Lazy-loaded plugins (Zinit turbo mode)
- Async git status (gitstatus daemon)
- Lazy-loaded kubectl completions
- Lazy-loaded Google Cloud SDK

## 🎨 Prompt Features

The Powerlevel10k prompt shows:

- **Full directory path** (no truncation)
- **Git status** (branch, dirty state, ahead/behind)
- **Kubernetes context** (only when using kubectl commands)
- **Language versions** (Node, Python, Java - only in relevant projects)
- **Command duration** (if >2 seconds)
- **Success/failure** indicator (green/red prompt character)

### Kubernetes context

The prompt shows your current k8s cluster when you use kubectl:

```
~ ☸ sandbox/consumer-mcp-sandbox
» kubectl get pods
```

This is **critical for safety** at DoorDash - you always know which cluster you're operating on!

## 📚 Documentation

All documentation has been consolidated into this README. Previous separate docs:
- ~~`README-SECRETS.md`~~ - Merged into this README
- ~~`QUICK-START-SECRETS.md`~~ - Merged into this README
- ~~`SCAN-AND-PURGE-SECRETS.md`~~ - Merged into this README
- ~~`SETUP-INSTRUCTIONS.md`~~ - Merged into this README

## 🤝 Contributing

Feel free to fork and customize for your own use! If you find bugs or have suggestions, open an issue.

## 📝 License

MIT - Do whatever you want with this!

## 🙏 Credits

Originally forked from [aeolyus/dotfiles](https://github.com/aeolyus/dotfiles) and heavily customized for DoorDash development workflow.

