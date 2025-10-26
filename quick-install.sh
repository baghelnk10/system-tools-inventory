#!/bin/bash
# System Tools Inventory - Quick Install Script
# Usage: curl -sSL https://raw.githubusercontent.com/baghelnk10/system-tools-inventory/main/quick-install.sh | sudo bash

set -e

echo "========================================="
echo "System Tools Inventory - Installation"
echo "========================================="
echo ""

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
  echo "❌ Please run with sudo"
  exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "📥 Downloading installation files..."

# Download required files
curl -sSL -o toolinfo https://raw.githubusercontent.com/baghelnk10/system-tools-inventory/main/toolinfo
curl -sSL -o inventory-template.json https://raw.githubusercontent.com/baghelnk10/system-tools-inventory/main/inventory-template.json

# Create documentation directory
echo "📁 Creating documentation directory..."
mkdir -p /usr/local/share/doc/system-tools

# Install toolinfo
echo "📦 Installing toolinfo command..."
cp toolinfo /usr/local/bin/toolinfo
chmod +x /usr/local/bin/toolinfo
echo "   ✓ toolinfo installed"

# Check if inventory exists
if [ -f /usr/local/share/doc/system-tools/inventory.json ]; then
  echo "📋 Existing inventory found"
  echo "   ✓ Preserving your existing inventory.json"
  
  # Create backup
  BACKUP_FILE="/usr/local/share/doc/system-tools/inventory.json.backup.$(date +%Y%m%d-%H%M%S)"
  cp /usr/local/share/doc/system-tools/inventory.json "$BACKUP_FILE"
  echo "   ✓ Backup created: $BACKUP_FILE"
else
  echo "📋 Installing inventory template..."
  cp inventory-template.json /usr/local/share/doc/system-tools/inventory.json
  
  # Try to auto-populate hostname and date
  HOSTNAME=$(hostname)
  CURRENT_DATE=$(date +%Y-%m-%d)
  sed -i "s/your-hostname/$HOSTNAME/" /usr/local/share/doc/system-tools/inventory.json
  sed -i "s/YYYY-MM-DD/$CURRENT_DATE/" /usr/local/share/doc/system-tools/inventory.json
  
  echo "   ✓ Inventory initialized"
  echo "   ✓ Auto-populated: hostname=$HOSTNAME"
fi

# Check for jq
if command -v jq &> /dev/null; then
  echo "✓ jq is already installed"
else
  echo "📦 Installing jq for better formatting..."
  if command -v dnf &> /dev/null; then
    dnf install -y jq 2>/dev/null && echo "   ✓ jq installed" || echo "   ⚠️  Could not install jq automatically"
  elif command -v yum &> /dev/null; then
    yum install -y jq 2>/dev/null && echo "   ✓ jq installed" || echo "   ⚠️  Could not install jq automatically"
  elif command -v apt-get &> /dev/null; then
    apt-get update -qq && apt-get install -y jq 2>/dev/null && echo "   ✓ jq installed" || echo "   ⚠️  Could not install jq automatically"
  else
    echo "   ⚠️  Could not install jq automatically"
  fi
fi

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo ""
echo "========================================="
echo "✅ Installation complete!"
echo "========================================="
echo ""
echo "Quick Start:"
echo "  toolinfo list              - List all custom tools"
echo "  toolinfo category          - Show all categories"
echo "  toolinfo show <tool>       - Show detailed info"
echo ""
echo "Configuration:"
echo "  toolinfo edit              - Edit inventory file"
echo "  toolinfo add               - Add new tool template"
echo ""
