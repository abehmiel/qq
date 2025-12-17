#!/usr/bin/env bash
# qq - Natural language to shell command converter using Ollama

qq() {
    # Check if Ollama is available
    if ! command -v ollama &> /dev/null; then
        echo "Error: ollama command not found. Please install Ollama first." >&2
        return 1
    fi

    # Check if any arguments were provided
    if [ $# -eq 0 ]; then
        echo "Usage: qq <natural language query>" >&2
        echo "Example: qq for each file in this directory, print the first line to stdout" >&2
        return 1
    fi

    # Combine all arguments into a single query
    local query="$*"

    # Detect the current shell
    local current_shell
    if [ -n "$BASH_VERSION" ]; then
        current_shell="bash"
    elif [ -n "$ZSH_VERSION" ]; then
        current_shell="zsh"
    elif [ -n "$FISH_VERSION" ]; then
        current_shell="fish"
    else
        current_shell=$(basename "$SHELL")
    fi

    # Build the prompt for Ollama
    local prompt="You are a ${current_shell} shell command generator. Convert the following natural language request into a single shell command. Output ONLY the best command, no explanations, no markdown, no additional text.

Request: ${query}

Command:"

    # Query Ollama API and get the command
    local command
    command=$(printf '%s' "$prompt" | python3 -c "
import json
import urllib.request
import sys

prompt = sys.stdin.read()

payload = {
    'model': '${QQ_MODEL:-devstral-2-small}',
    'prompt': prompt,
    'stream': False
}

try:
    req = urllib.request.Request(
        'http://localhost:11434/api/generate',
        data=json.dumps(payload).encode('utf-8'),
        headers={'Content-Type': 'application/json'}
    )
    with urllib.request.urlopen(req, timeout=30) as response:
        result = json.loads(response.read().decode('utf-8'))
        output = result.get('response', '').strip()
        # Remove markdown code fences if present
        if output.startswith('\`\`\`'):
            output = output.split('\n', 1)[1] if '\n' in output else output[3:]
        if output.endswith('\`\`\`'):
            output = output.rsplit('\n', 1)[0] if '\n' in output else output[:-3]
        print(output.strip().strip('\`'))
except Exception:
    sys.exit(1)
" 2>/dev/null)

    if [ -z "$command" ]; then
        echo "Error: Failed to generate command from Ollama" >&2
        return 1
    fi

    # Auto-populate the shell based on shell type
    if [ -n "$ZSH_VERSION" ]; then
        # For zsh, use print -z to populate the buffer
        print -z "$command" 2>/dev/null || echo "$command"
    elif [ -n "$BASH_VERSION" ]; then
        # For bash, use history and readline
        history -s "$command" 2>/dev/null || true
        echo "$command"
        echo "(Press Up arrow to edit, or copy the command above)"
    elif [ -n "$FISH_VERSION" ]; then
        # For fish, use commandline
        commandline "$command" 2>/dev/null || echo "$command"
    else
        # Fallback: just print the command
        echo "$command"
        echo "(Command generated - please copy and paste)"
    fi
}
