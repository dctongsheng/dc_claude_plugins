#!/bin/bash
# SSH Edit - Edit an SSH connection

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_FILE="$SCRIPT_DIR/../data/connections.jsonl"

# Validate arguments
if [ -z "$1" ]; then
    echo "Error: Missing connection index."
    echo ""
    echo "Usage: /ssh-edit <index> <field>=<value> [<field>=<value> ...]"
    echo ""
    echo "Available fields: name, host, user, port, identity_file, description"
    echo "Example:"
    echo "  /ssh-edit 1 host=new.example.com"
    echo "  /ssh-edit 1 port=2222 description=\"Updated server\""
    exit 1
fi

if [ -z "$2" ]; then
    echo "Error: No fields to update."
    echo "Usage: /ssh-edit <index> <field>=<value> [<field>=<value> ...]"
    exit 1
fi

index=$1
shift
updates="$@"

line_num=0
temp_file=$(mktemp)
updated=false

# Process each line
while IFS= read -r line; do
    if [ -n "$line" ]; then
        ((line_num++))
        if [ "$line_num" -eq "$index" ]; then
            updated_line="$line"

            # Parse and apply updates
            for update in $updates; do
                key=$(echo "$update" | cut -d'=' -f1)
                value=$(echo "$update" | cut -d'=' -f2-)

                # Remove quotes from value if present
                value=$(echo "$value" | sed 's/^["\x27]\(.*\)["\x27]$/\1/')

                case "$key" in
                    port)
                        updated_line=$(echo "$updated_line" | jq --argjson v "$value" '.port = $v')
                        ;;
                    description|identity_file)
                        if [ "$value" = "null" ] || [ -z "$value" ]; then
                            updated_line=$(echo "$updated_line" | jq ".$key = null")
                        else
                            updated_line=$(echo "$updated_line" | jq --arg v "$value" ".$key = \$v")
                        fi
                        ;;
                    *)
                        updated_line=$(echo "$updated_line" | jq --arg v "$value" ".$key = \$v")
                        ;;
                esac
            done

            # Update timestamp
            updated_line=$(echo "$updated_line" | jq --arg v "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" '.updated_at = $v')

            echo "$updated_line" >> "$temp_file"
            updated=true
        else
            echo "$line" >> "$temp_file"
        fi
    fi
done < "$DATA_FILE"

# Replace file
mv "$temp_file" "$DATA_FILE"

# Show result
if [ "$updated" = true ]; then
    echo "✓ SSH connection #$index updated successfully."
else
    echo "Error: Connection #$index not found."
    exit 1
fi
