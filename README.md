# homebrew-tellr

Homebrew tap for [tellr](https://github.com/robertwhiffin/ai-slide-generator) — AI-powered slide generator for Databricks.

Generate presentation-ready slides from your Databricks data through natural conversation.

---

## Requirements

You need:
- **macOS**
- **Homebrew** — Install from [brew.sh](https://brew.sh) if you don't have it:
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- **Access to a Databricks workspace**

The formula automatically installs these dependencies:
- Python 3.11
- PostgreSQL 14  
- Node.js 18

---

## Installation

```bash
# Add the tap
brew tap RickTY94/tellr

# Install tellr
brew install tellr
```

This will install tellr and all required dependencies (Python, PostgreSQL, Node.js).

---

## Quick Start

```bash
# Start tellr
tellr
```

Your browser will open to http://localhost:3000. On first run:

![Welcome Screen](Welcome%20to%20tellr.png)

1. **Enter your Databricks workspace URL** (e.g., `https://your-workspace.cloud.databricks.com`)
2. **Sign in** with your Databricks credentials
3. **Start generating slides!**

No PAT tokens required — just your normal Databricks login.

---

## Commands

| Command | Description |
|---------|-------------|
| `tellr` | Start the app (opens browser) |
| `tellr start` | Start the app |
| `tellr stop` | Stop the app |
| `tellr status` | Check if running & show config |
| `tellr reset` | Reset workspace configuration |
| `tellr logs` | View recent logs |
| `tellr --help` | Show all commands |

---

## Updating

```bash
brew upgrade tellr
```

---

## Uninstalling

```bash
brew uninstall tellr
brew untap RickTY94/tellr
```

---

## Troubleshooting

### PostgreSQL not running
```bash
brew services start postgresql@14
```

### Reset configuration
```bash
tellr reset
```
Then restart tellr to re-enter your workspace URL.

### View logs
```bash
tellr logs
```

---

## Links

- [tellr documentation](https://robertwhiffin.github.io/ai-slide-generator/) — Full user guide, API reference & technical docs
- [tellr source code](https://github.com/robertwhiffin/ai-slide-generator)
- [Report an issue](https://github.com/RickTY94/homebrew-tellr/issues)

---

## License

Apache 2.0
