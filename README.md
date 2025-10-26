# System Tools Inventory

A simple JSON-based documentation system for tracking custom tools, binaries, and scripts on Linux systems with support for multiple categories.

## Features

- 📋 JSON-based inventory for machine-readable documentation
- 🗂️ **Category support** - Organize tools by type (custom_tools, klmhv_tools, system_scripts, etc.)
- 🔍 Quick CLI tool (`toolinfo`) to list and query installed tools
- 🔎 **Search functionality** - Find tools by name or purpose across all categories
- 📝 Easy to edit and maintain
- 🚀 Simple installation script
- 💼 Perfect for documenting custom builds, compiled binaries, and scripts

## Installation

### Quick Install
```bash
curl -sSL https://raw.githubusercontent.com/baghelnk10/system-tools-inventory/main/quick-install.sh | sudo bash
```

### Manual Install
```bash
git clone https://github.com/baghelnk10/system-tools-inventory.git
cd system-tools-inventory
sudo ./install.sh
```

## Quick Start

```bash
# List all tools
toolinfo list

# List tools by category
toolinfo list klmhv_tools

# Show all categories
toolinfo category

# Search for tools
toolinfo search monitoring

# Show tool details
toolinfo show colorfultail
```

## Usage Examples

### List all tools (all categories)
```bash
$ toolinfo list

=== Custom Tools Inventory ===

--- custom_tools ---
[colorfultail]
  Location: /usr/local/bin/colorfultail
  Purpose: Colorized log file viewer
  Usage: colorfultail [-f] <file>

--- klmhv_tools ---
[klmhv-monitor]
  Location: /opt/klmhv/bin/monitor
  Purpose: KLMHV system monitoring
  Usage: klmhv-monitor [options]
```

### Show categories
```bash
$ toolinfo category

=== Categories ===
[custom_tools]
  Tools: 3

[klmhv_tools]
  Tools: 5

[system_scripts]
  Tools: 2
```

### Search tools
```bash
$ toolinfo search backup

=== Search Results for 'backup' ===
[backup-script] (in system_scripts)
  Purpose: System backup automation
  Location: /usr/local/sbin/backup.sh
```

## File Structure

```
/usr/local/share/doc/system-tools/
├── inventory.json              # Main inventory file (with categories)
└── [tool-name]-BUILD.md        # Tool-specific documentation

/usr/local/bin/
└── toolinfo                    # CLI helper tool
```

## Inventory Structure with Categories

```json
{
  "system": {
    "hostname": "your-hostname",
    "os": "Rocky Linux",
    "last_updated": "2025-10-26",
    "maintained_by": "your-name"
  },
  "custom_tools": [
    { "name": "tool1", ... }
  ],
  "klmhv_tools": [
    { "name": "klmhv-specific-tool", ... }
  ],
  "system_scripts": [
    { "name": "backup-script", ... }
  ]
}
```

## Supported Categories

- **custom_tools**: General custom tools and binaries
- **klmhv_tools**: KLMHV-specific tools and utilities
- **system_scripts**: System automation and maintenance scripts
- **[your_category]**: Create your own categories as needed!

## Tool Entry Example

```json
{
  "name": "colorfultail",
  "location": "/usr/local/bin/colorfultail",
  "type": "binary",
  "language": "go",
  "compiled_by": "username",
  "build_date": "2023-03-23",
  "size_bytes": 1769472,
  "portable": true,
  "dependencies": [
    "github.com/fatih/color@v1.10.0",
    "github.com/hpcloud/tail@v1.0.0"
  ],
  "usage": "colorfultail [-f] <file>",
  "purpose": "Colorized log file viewer",
  "examples": [
    "colorfultail /var/log/messages",
    "colorfultail -f /var/log/app.log"
  ],
  "documentation": "/usr/local/share/doc/system-tools/colorfultail-BUILD.md",
  "notes": "Statically-linked, portable binary"
}
```

## Command Reference

| Command | Description |
|---------|-------------|
| `toolinfo list` | List all tools in all categories |
| `toolinfo list <category>` | List tools in specific category |
| `toolinfo category` | List all categories with tool counts |
| `toolinfo category <name>` | Show tools in a specific category |
| `toolinfo show <tool>` | Show detailed info about a tool |
| `toolinfo search <query>` | Search tools by name or purpose |
| `toolinfo add` | Show template for adding new tool |
| `toolinfo edit` | Edit inventory file |
| `toolinfo path` | Show inventory file location |

## Customizing for Your System

After installation:

```bash
toolinfo edit
```

Update the `system` section and add your tools to the appropriate categories.

## Requirements

- Linux system with bash
- `sudo` access for installation
- Optional: `jq` for better formatted output (auto-installed)

## Documentation

- [Usage Guide](USAGE.md) - Detailed usage examples and workflows
- [Template](inventory-template.json) - JSON template for new systems

## Uninstall

```bash
sudo rm /usr/local/bin/toolinfo
rm -rf ~/.config/system-tools
```

## Contributing

Feel free to submit issues or pull requests!

## License

MIT License - Feel free to use and modify
