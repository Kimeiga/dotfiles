#!/bin/bash
# Helper script to create encrypted secrets files

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 Create Encrypted Secrets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if SOPS is installed
if ! command -v sops &> /dev/null; then
    echo "❌ SOPS not installed. Run ./setup-secrets.sh first"
    exit 1
fi

echo "This script will help you create encrypted secrets files."
echo ""
echo "You'll need:"
echo "  1. NEW Artifactory password (rotate the old one first!)"
echo "  2. Refact.ai API key"
echo "  3. OpenWeatherMap API key"
echo ""

# DoorDash Artifactory
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  DoorDash Artifactory"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Enter your NEW Artifactory password: " ARTIFACTORY_PASSWORD

if [ -z "$ARTIFACTORY_PASSWORD" ]; then
    echo "❌ Password cannot be empty"
    exit 1
fi

cat > /tmp/doordash.env << EOF
# DoorDash Artifactory credentials
ARTIFACTORY_USERNAME=hakan.alpay@doordash.com
ARTIFACTORY_PASSWORD=$ARTIFACTORY_PASSWORD
EOF

sops --encrypt /tmp/doordash.env > secrets/doordash.env
rm /tmp/doordash.env
echo "✅ Created encrypted secrets/doordash.env"
echo ""

# Refact.ai
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  Refact.ai"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Enter your Refact.ai API key (or press Enter to skip): " REFACTAI_API_KEY

if [ -n "$REFACTAI_API_KEY" ]; then
    cat > /tmp/refactai.env << EOF
# Refact.ai API Key
REFACTAI_API_KEY=$REFACTAI_API_KEY
EOF

    sops --encrypt /tmp/refactai.env > secrets/refactai.env
    rm /tmp/refactai.env
    echo "✅ Created encrypted secrets/refactai.env"
else
    echo "⏭️  Skipped Refact.ai"
fi
echo ""

# OpenWeatherMap
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣  OpenWeatherMap"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Enter your OpenWeatherMap API key (or press Enter to skip): " OPENWEATHERMAP_API_KEY

if [ -n "$OPENWEATHERMAP_API_KEY" ]; then
    cat > /tmp/openweathermap.env << EOF
# OpenWeatherMap API Key
OPENWEATHERMAP_API_KEY=$OPENWEATHERMAP_API_KEY
EOF

    sops --encrypt /tmp/openweathermap.env > secrets/openweathermap.env
    rm /tmp/openweathermap.env
    echo "✅ Created encrypted secrets/openweathermap.env"
else
    echo "⏭️  Skipped OpenWeatherMap"
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Encrypted secrets created!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Verify encryption worked:"
echo "   cat secrets/doordash.env  # Should show encrypted data"
echo ""
echo "2. Test decryption:"
echo "   sops --decrypt secrets/doordash.env  # Should show your password"
echo ""
echo "3. Update your .zshrc to load these secrets"
echo "   (I'll help you with this next)"
echo ""

