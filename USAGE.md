# Usage Guide

## Installation on a New System

### Method 1: Quick Install (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/system-tools-inventory/main/install.sh | sudo bash
```

### Method 2: Clone and Install
```bash
git clone https://github.com/YOUR_USERNAME/system-tools-inventory.git
cd system-tools-inventory
sudo ./install.sh
```

## Basic Commands

### List all tools (all categories)
```bash
toolinfo list
```

Output:
```
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

### List tools by category
```bash
toolinfo list custom_tools
toolinfo list klmhv_tools
toolinfo list system_scripts
```

### List all categories
```bash
toolinfo category
```

Output:
```
=== Categories ===
[custom_tools]
  Tools: 3

[klmhv_tools]
  Tools: 5

[system_scripts]
  Tools: 2
```

### Show category details
```bash
toolinfo category klmhv_tools
```

### Show tool details
```bash
toolinfo show colorfultail
```

### Search for tools
```bash
toolinfo search backup
toolinfo search monitoring
```

### Add a new tool
```bash
# Show template
toolinfo add

# Edit inventory
toolinfo edit
```

### Edit inventory directly
```bash
toolinfo edit
```

### Get inventory file path
```bash
toolinfo path
```

## Working with Categories

### Understanding Categories

The inventory supports multiple categories to organize tools:

- **custom_tools**: General custom tools and binaries
- **klmhv_tools**: KLMHV-specific tools and utilities
- **system_scripts**: System automation and maintenance scripts
- **[your_category]**: Create your own categories as needed

### Adding a New Category

Edit the inventory and add a new top-level key:

```bash
toolinfo edit
```

```json
{
  "system": { ... },
  "custom_tools": [ ... ],
  "klmhv_tools": [ ... ],
  "your_new_category": [
    {
      "name": "new-tool",
      ...
    }
  ]
}
```

### Example: KLMHV-Specific Tools

```json
{
  "klmhv_tools": [
    {
      "name": "klmhv-monitor",
      "location": "/opt/klmhv/bin/monitor",
      "type": "binary",
      "language": "python",
      "compiled_by": "klmhv-team",
      "build_date": "2025-01-15",
      "size_bytes": 125000,
      "portable": false,
      "dependencies": [
        "python3.8+",
        "psutil",
        "prometheus-client"
      ],
      "usage": "klmhv-monitor [--interval 60] [--config /etc/klmhv/monitor.conf]",
      "purpose": "Monitor KLMHV system resources and export metrics",
      "examples": [
        "klmhv-monitor --interval 30",
        "klmhv-monitor --config /etc/klmhv/custom.conf"
      ],
      "documentation": "/opt/klmhv/docs/monitor.md",
      "notes": "Requires KLMHV environment. Auto-starts via systemd."
    }
  ]
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

## Example Workflows

### Documenting a KLMHV System

```bash
# 1. Install toolinfo
sudo ./install.sh

# 2. List categories
toolinfo category

# 3. Add KLMHV-specific tools
toolinfo edit
# Add tools to the "klmhv_tools" section

# 4. View KLMHV tools only
toolinfo list klmhv_tools

# 5. Search for specific functionality
toolinfo search monitor
```

### Managing Multiple Tool Types

```bash
# View all tools
toolinfo list

# View only custom compiled tools
toolinfo list custom_tools

# View only system scripts
toolinfo list system_scripts

# View only KLMHV tools
toolinfo list klmhv_tools

# Search across all categories
toolinfo search backup
```

## Tips

- Use descriptive category names (e.g., `production_tools`, `dev_tools`, `monitoring_tools`)
- Keep `last_updated` current when making changes
- Add tool-specific documentation files to `/usr/local/share/doc/system-tools/`
- Reference those files in the `documentation` field
- Use `notes` fields for deployment-specific information
- Update `examples` with real-world usage scenarios

## Integration with Other Systems

### Export specific category
```bash
jq '.klmhv_tools' $(toolinfo path)
```

### Copy category to another system
```bash
jq '.klmhv_tools' /usr/local/share/doc/system-tools/inventory.json > klmhv-tools.json
scp klmhv-tools.json user@remote-host:/tmp/
```

### Backup entire inventory
```bash
cp /usr/local/share/doc/system-tools/inventory.json ~/backups/inventory-$(date +%Y%m%d).json
```

### Generate tool list for documentation
```bash
toolinfo list > system-tools-inventory.txt
```
