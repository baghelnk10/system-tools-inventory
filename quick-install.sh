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

# Get the actual user (not root when using sudo)
ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(eval echo ~$ACTUAL_USER)

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "📥 Downloading installation files..."

# Download required files
curl -sSL -o toolinfo https://raw.githubusercontent.com/baghelnk10/system-tools-inventory/main/toolinfo
curl -sSL -o inventory-template.json https://raw.githubusercontent.com/baghelnk10/system-tools-inventory/main/inventory-template.json

# Create config directory in user's home
echo "📁 Creating config directory..."
mkdir -p "$ACTUAL_HOME/.config/system-tools"
chown -R "$ACTUAL_USER:$ACTUAL_USER" "$ACTUAL_HOME/.config/system-tools"

# Install toolinfo
echo "📦 Installing toolinfo command..."
cp toolinfo /usr/local/bin/toolinfo
chmod +x /usr/local/bin/toolinfo
echo "   ✓ toolinfo installed"

# Check if inventory exists
if [ -f "$ACTUAL_HOME/.config/system-tools/inventory.json" ]; then
  echo "📋 Existing inventory found"
  echo "   ✓ Preserving your existing inventory.json"
  
  # Create backup
  BACKUP_FILE="$ACTUAL_HOME/.config/system-tools/inventory.json.backup.$(date +%Y%m%d-%H%M%S)"
  cp "$ACTUAL_HOME/.config/system-tools/inventory.json" "$BACKUP_FILE"
  chown "$ACTUAL_USER:$ACTUAL_USER" "$BACKUP_FILE"
  echo "   ✓ Backup created: $BACKUP_FILE"
else
  echo "📋 Installing inventory template..."
  cp inventory-template.json "$ACTUAL_HOME/.config/system-tools/inventory.json"
  chown "$ACTUAL_USER:$ACTUAL_USER" "$ACTUAL_HOME/.config/system-tools/inventory.json"
  
  # Try to auto-populate hostname and date
  HOSTNAME=$(hostname)
  CURRENT_DATE=$(date +%Y-%m-%d)
  sed -i "s/your-hostname/$HOSTNAME/" "$ACTUAL_HOME/.config/system-tools/inventory.json"
  sed -i "s/YYYY-MM-DD/$CURRENT_DATE/" "$ACTUAL_HOME/.config/system-tools/inventory.json"
  
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
echo "  toolinfo edit              - Edit inventory file (no sudo needed!)"
echo "  toolinfo add               - Add new tool template"
echo ""
echo "Inventory location: $ACTUAL_HOME/.config/system-tools/inventory.json"
echo ""
