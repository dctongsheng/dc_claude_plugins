#!/bin/bash
# SSH Delete - Delete an SSH connection

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_FILE="$SCRIPT_DIR/../data/connections.jsonl"

# Validate argument
if [ -z "$1" ]; then
    echo "Error: Missing connection index."
    echo ""
    echo "Usage: /ssh-delete <index>"
    echo "Use '/ssh-list' to find the index."
    exit 1
fi

index=$1
line_num=0
temp_file=$(mktemp)
deleted_name=""

# Read and filter
while IFS= read -r line; do
    if [ -n "$line" ]; then
        ((line_num++))
        if [ "$line_num" -ne "$index" ]; then
            echo "$line" >> "$temp_file"
        else
            deleted_name=$(echo "$line" | jq -r '.name')
        fi
    fi
done < "$DATA_FILE"

# Replace file
mv "$temp_file" "$DATA_FILE"

# Show result
if [ -n "$deleted_name" ]; then
    echo "✓ SSH connection '$deleted_name' deleted successfully."
else
    echo "Error: Connection #$index not found."
    exit 1
fi
