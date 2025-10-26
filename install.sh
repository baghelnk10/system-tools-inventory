#!/bin/bash
# System Tools Inventory - Installation Script

set -e

echo "========================================="
echo "System Tools Inventory - Installation"
echo "========================================="
echo ""

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
  echo "❌ Please run with sudo: sudo ./install.sh"
  exit 1
fi

# Get the actual user (not root when using sudo)
ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(eval echo ~$ACTUAL_USER)

# Create config directory in user's home
echo "📁 Creating config directory..."
mkdir -p "$ACTUAL_HOME/.config/system-tools"
chown -R "$ACTUAL_USER:$ACTUAL_USER" "$ACTUAL_HOME/.config/system-tools"

# Check if toolinfo exists
if [ -f /usr/local/bin/toolinfo ]; then
  echo "🔄 Updating toolinfo command..."
  cp toolinfo /usr/local/bin/toolinfo
  chmod +x /usr/local/bin/toolinfo
  echo "   ✓ toolinfo updated to latest version"
else
  echo "📦 Installing toolinfo command..."
  cp toolinfo /usr/local/bin/toolinfo
  chmod +x /usr/local/bin/toolinfo
  echo "   ✓ toolinfo installed"
fi

# Check if inventory exists
if [ -f "$ACTUAL_HOME/.config/system-tools/inventory.json" ]; then
  echo "📋 Existing inventory found"
  echo "   ✓ Preserving your existing inventory.json"
  echo "   ℹ️  Location: $ACTUAL_HOME/.config/system-tools/inventory.json"
  
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
  
  echo "   ✓ Inventory initialized at: $ACTUAL_HOME/.config/system-tools/inventory.json"
  echo "   ✓ Auto-populated: hostname=$HOSTNAME, date=$CURRENT_DATE"
fi

# Check for jq
if command -v jq &> /dev/null; then
  echo "✓ jq is already installed"
else
  echo "📦 Installing jq for better formatting..."
  if command -v dnf &> /dev/null; then
    dnf install -y jq 2>/dev/null && echo "   ✓ jq installed" || echo "   ⚠️  Could not install jq automatically. Install manually: sudo dnf install jq"
  elif command -v yum &> /dev/null; then
    yum install -y jq 2>/dev/null && echo "   ✓ jq installed" || echo "   ⚠️  Could not install jq automatically. Install manually: sudo yum install jq"
  elif command -v apt-get &> /dev/null; then
    apt-get update && apt-get install -y jq 2>/dev/null && echo "   ✓ jq installed" || echo "   ⚠️  Could not install jq automatically. Install manually: sudo apt-get install jq"
  else
    echo "   ⚠️  Could not install jq automatically. Install manually for better formatting."
  fi
fi

echo ""
echo "========================================="
echo "✅ Installation complete!"
echo "========================================="
echo ""
echo "Quick Start:"
echo "  toolinfo list              - List all custom tools"
echo "  toolinfo category          - Show all categories"
echo "  toolinfo show <tool>       - Show detailed info about a tool"
echo "  toolinfo search <query>    - Search for tools"
echo ""
echo "Configuration:"
echo "  toolinfo edit              - Edit inventory file"
echo "  toolinfo add               - Show template for adding new tool"
echo ""
echo "Documentation:"
echo "  Inventory: $ACTUAL_HOME/.config/system-tools/inventory.json"
echo "  Command:   /usr/local/bin/toolinfo"
echo ""
