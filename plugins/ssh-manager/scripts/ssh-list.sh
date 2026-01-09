#!/bin/bash
# SSH List - Simple implementation without function dependencies

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_FILE="$SCRIPT_DIR/../data/connections.jsonl"

if [ ! -s "$DATA_FILE" ]; then
    echo "No SSH connections found."
    echo "Use '/ssh-add' to add a new connection."
    exit 0
fi

echo "SSH Connections:"
echo ""
printf "%-5s %-20s %-30s %-15s %-10s\n" "ID" "Name" "Host" "User" "Port"
echo "------------------------------------------------------------------------------------------------"

index=1
while IFS= read -r line; do
    if [ -n "$line" ]; then
        name=$(echo "$line" | jq -r '.name')
        host=$(echo "$line" | jq -r '.host')
        user=$(echo "$line" | jq -r '.user')
        port=$(echo "$line" | jq -r '.port // 22')

        printf "%-5s %-20s %-30s %-15s %-10s\n" "$index" "$name" "$host" "$user" "$port"
        ((index++))
    fi
done < "$DATA_FILE"
echo ""
