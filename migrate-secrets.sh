#!/bin/bash
# Migrate secrets from .zshrc to encrypted SOPS files

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Migrating Secrets from .zshrc to SOPS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if SOPS is installed
if ! command -v sops &> /dev/null; then
    echo "❌ SOPS not installed. Run ./setup-secrets.sh first"
    exit 1
fi

# Check if age key exists
AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
if [ ! -f "$AGE_KEY_FILE" ]; then
    echo "❌ Age key not found. Run ./setup-secrets.sh first"
    exit 1
fi

# Check if .sops.yaml has been updated
if grep -q "age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" .sops.yaml; then
    echo "❌ Please update .sops.yaml with your actual age public key first!"
    echo ""
    echo "Your public key is:"
    grep "# public key:" "$AGE_KEY_FILE"
    echo ""
    echo "Replace the placeholder in .sops.yaml with this key"
    exit 1
fi

echo "✅ Prerequisites met"
echo ""

# Create secrets directory
mkdir -p secrets

# Extract DoorDash/Artifactory secrets from .zshrc
echo "📝 Extracting DoorDash/Artifactory secrets..."

cat > secrets/doordash.env << 'EOF'
# DoorDash Artifactory credentials
# These are used for accessing internal Python packages and npm packages

ARTIFACTORY_USERNAME=hakan.alpay@doordash.com
ARTIFACTORY_PASSWORD=***REMOVED***
EOF

echo "✅ Created secrets/doordash.env"
echo ""

# Encrypt the file
echo "🔐 Encrypting secrets with SOPS..."
sops --encrypt --in-place secrets/doordash.env
echo "✅ Encrypted secrets/doordash.env"
echo ""

# Create a template .zshrc snippet
cat > secrets/zshrc-snippet.txt << 'EOF'
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Secrets (loaded from encrypted SOPS files)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Load DoorDash/Artifactory secrets
if command -v sops &> /dev/null && [ -f ~/dotfiles/secrets/doordash.env ]; then
  # Decrypt and export all variables from the secrets file
  while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^#.*$ ]] && continue
    [[ -z "$key" ]] && continue
    # Export the variable
    export "$key=$value"
  done < <(sops --decrypt ~/dotfiles/secrets/doordash.env 2>/dev/null || true)
  
  # Derived variables (computed from secrets)
  if [ -n "$ARTIFACTORY_USERNAME" ] && [ -n "$ARTIFACTORY_PASSWORD" ]; then
    export artifactoryUser=${ARTIFACTORY_USERNAME}
    export artifactoryPassword=${ARTIFACTORY_PASSWORD}
    export ARTIFACTORY_URL=https://${ARTIFACTORY_USERNAME/@/%40}:${ARTIFACTORY_PASSWORD}@ddartifacts.jfrog.io/ddartifacts/api/pypi/pypi-local/simple/
    export PIP_EXTRA_INDEX_URL=${ARTIFACTORY_URL}
  fi
fi
EOF

echo "✅ Created secrets/zshrc-snippet.txt"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Migration Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Replace the Artifactory section in zsh/.zshrc with:"
echo "   cat secrets/zshrc-snippet.txt"
echo ""
echo "2. Test that secrets load correctly:"
echo "   source ~/.zshrc"
echo "   echo \$ARTIFACTORY_USERNAME"
echo ""
echo "3. Commit the encrypted secrets:"
echo "   git add secrets/doordash.env .sops.yaml"
echo "   git commit -m 'Add encrypted secrets with SOPS'"
echo ""
echo "4. Remove the old plaintext secrets from .zshrc"
echo ""
echo "5. Push to GitHub - your secrets are now safe! 🎉"
echo ""

