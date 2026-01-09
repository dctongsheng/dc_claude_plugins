#!/bin/bash
# SSH Add - Add a new SSH connection

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_FILE="$SCRIPT_DIR/../data/connections.jsonl"

# Ensure data file exists
if [ ! -f "$DATA_FILE" ]; then
    touch "$DATA_FILE"
fi

# Parse arguments
name="$1"
host="$2"
user="$3"
port="${4:-22}"
identity_file="$5"
description="$6"

# Validate required arguments
if [ -z "$name" ] || [ -z "$host" ] || [ -z "$user" ]; then
    echo "Error: Missing required arguments."
    echo ""
    echo "Usage: /ssh-add <name> <host> <user> [port] [identity_file] [description]"
    echo ""
    echo "Example:"
    echo "  /ssh-add production prod.example.com admin"
    echo "  /ssh-add production prod.example.com admin 2222"
    echo "  /ssh-add production prod.example.com admin 22 ~/.ssh/id_rsa \"Production server\""
    exit 1
fi

# Check if connection already exists
if grep -q "\"name\":\"$name\"" "$DATA_FILE" 2>/dev/null; then
    echo "Error: Connection '$name' already exists."
    echo "Use '/ssh-edit' to modify it."
    exit 1
fi

# Generate ID and timestamp
id=$(date +%s)${RANDOM}
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Build JSON (single line to avoid formatting issues)
if [ -n "$identity_file" ]; then
  if [ -n "$description" ]; then
    json="{\"id\":\"$id\",\"name\":\"$name\",\"host\":\"$host\",\"user\":\"$user\",\"port\":$port,\"identity_file\":\"$identity_file\",\"description\":\"$description\",\"created_at\":\"$timestamp\",\"updated_at\":\"$timestamp\"}"
  else
    json="{\"id\":\"$id\",\"name\":\"$name\",\"host\":\"$host\",\"user\":\"$user\",\"port\":$port,\"identity_file\":\"$identity_file\",\"description\":null,\"created_at\":\"$timestamp\",\"updated_at\":\"$timestamp\"}"
  fi
else
  if [ -n "$description" ]; then
    json="{\"id\":\"$id\",\"name\":\"$name\",\"host\":\"$host\",\"user\":\"$user\",\"port\":$port,\"identity_file\":null,\"description\":\"$description\",\"created_at\":\"$timestamp\",\"updated_at\":\"$timestamp\"}"
  else
    json="{\"id\":\"$id\",\"name\":\"$name\",\"host\":\"$host\",\"user\":\"$user\",\"port\":$port,\"identity_file\":null,\"description\":null,\"created_at\":\"$timestamp\",\"updated_at\":\"$timestamp\"}"
  fi
fi

# Save to file
echo "$json" >> "$DATA_FILE"

echo "✓ SSH connection '$name' added successfully."
echo ""
echo "Connection details:"
echo "  Name: $name"
echo "  Host: $host"
echo "  User: $user"
echo "  Port: $port"
[ -n "$identity_file" ] && echo "  Identity: $identity_file"
[ -n "$description" ] && echo "  Description: $description"
