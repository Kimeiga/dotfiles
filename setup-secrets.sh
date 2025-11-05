#!/bin/bash
# Setup script for SOPS secrets management

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 SOPS Secrets Management Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if SOPS is installed
if ! command -v sops &> /dev/null; then
    echo "❌ SOPS not found. Installing..."
    brew install sops
    echo "✅ SOPS installed"
else
    echo "✅ SOPS already installed ($(sops --version))"
fi

# Check if age is installed
if ! command -v age &> /dev/null; then
    echo "❌ age not found. Installing..."
    brew install age
    echo "✅ age installed"
else
    echo "✅ age already installed"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔑 Age Key Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"

if [ -f "$AGE_KEY_FILE" ]; then
    echo "✅ Age key already exists at: $AGE_KEY_FILE"
    echo ""
    echo "Your public key:"
    grep "# public key:" "$AGE_KEY_FILE"
else
    echo "📝 Generating new age key pair..."
    mkdir -p "$(dirname "$AGE_KEY_FILE")"
    age-keygen -o "$AGE_KEY_FILE"
    echo ""
    echo "✅ Age key generated at: $AGE_KEY_FILE"
    echo ""
    echo "⚠️  IMPORTANT: Back up this key securely!"
    echo "   - Save it to 1Password or another password manager"
    echo "   - You'll need it to decrypt secrets on new machines"
    echo ""
    echo "Your public key:"
    grep "# public key:" "$AGE_KEY_FILE"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Update .sops.yaml with your public key (shown above)"
echo "2. Run: ./migrate-secrets.sh"
echo "3. Update your .zshrc to load encrypted secrets"
echo "4. Commit encrypted secrets to git"
echo ""
echo "See README-SECRETS.md for detailed instructions"
echo ""

