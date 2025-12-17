# qq - Natural Language Shell Commands

A minimal bash utility that converts natural language queries into shell commands using a local Ollama instance.

## Prerequisites

- **Ollama** installed and running on your machine
  - Install from: https://ollama.ai
  - Pull a model: `ollama pull devstral-2-small` (or any other model you prefer)

## Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd qq
```

2. Run the installation script:
```bash
./install.sh
```

3. Reload your shell:
```bash
source ~/.bashrc  # or ~/.zshrc for zsh users
```

## Usage

Simply type `qq` followed by your natural language request:

```bash
qq for each file in this directory, print the first line to stdout
```

This will automatically generate and populate your shell with:
```bash
find . -maxdepth 1 -type f -exec head -n 1 {} \;
```

### How it works

1. **Shell Detection**: `qq` automatically detects your shell (bash, zsh, or fish)
2. **Query Processing**: Sends your natural language request to Ollama with shell-specific context
3. **Command Generation**: Ollama generates the appropriate shell command
4. **Auto-population**:
   - **zsh**: Command appears directly in your prompt buffer (ready to execute)
   - **bash**: Command is added to history (press Up arrow to access)
   - **fish**: Command appears in your command line buffer
   - **Other shells**: Command is printed to stdout

## Configuration

### Changing the Ollama Model

By default, `qq` uses the `devstral-2-small` model. To use a different model, set the `QQ_MODEL` environment variable:

```bash
export QQ_MODEL=codellama  # Add to your ~/.bashrc or ~/.zshrc
```

### Recommended Ollama Models

For best results with shell commands:
- `devstral-2-small` (default, fast and efficient)
- `codellama` (optimized for code)
- `llama3.2` (fast and accurate)
- `llama3.1` (larger, more capable)

Pull a model with:
```bash
ollama pull devstral-2-small
```

## Examples

```bash
# File operations
qq list all python files modified in the last 7 days

# Text processing
qq count the number of lines in all txt files

# System information
qq show disk usage sorted by size

# Git operations
qq show all commits from the last week

# Process management
qq find and kill all node processes
```

## Tips

- Be specific in your requests for better results
- The generated command appears instantly (1-2 seconds)
- Review generated commands before executing them
- For complex operations, you can refine the natural language query

## Troubleshooting

### Ollama not found
```bash
# Check if Ollama is installed
which ollama

# Install Ollama if needed
# Visit https://ollama.ai
```

### Slow responses
```bash
# Use a smaller, faster model
export QQ_MODEL=devstral-2-small

# Ensure Ollama is running
ollama list
```

### Commands not auto-populating
- Make sure you've reloaded your shell after installation
- For bash, use the Up arrow to access the generated command from history
- Check that the installation added the source line to your RC file

## Uninstallation

Remove the source line from your shell RC file:
```bash
# Edit ~/.bashrc or ~/.zshrc and remove:
source "/path/to/qq/qq.sh"
```

## License

MIT

## Contributing

Contributions welcome! Please open an issue or pull request.
