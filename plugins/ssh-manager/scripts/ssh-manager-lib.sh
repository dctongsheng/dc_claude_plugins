#!/bin/bash
# SSH Manager Library - Handle JSONL operations for SSH connections

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DATA_FILE="$SCRIPT_DIR/../data/connections.jsonl"

# Ensure data file exists
ensure_data_file() {
    if [ ! -f "$DATA_FILE" ]; then
        touch "$DATA_FILE"
    fi
}

# Generate unique ID
generate_id() {
    date +%s%N
}

# List all SSH connections
list_connections() {
    ensure_data_file

    if [ ! -s "$DATA_FILE" ]; then
        echo "No SSH connections found."
        echo "Use '/ssh-add' to add a new connection."
        return 0
    fi

    echo "SSH Connections:"
    echo ""
    printf "%-5s %-20s %-30s %-15s %-10s\n" "ID" "Name" "Host" "User" "Port"
    echo "------------------------------------------------------------------------------------------------"

    local index=1
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            local name=$(echo "$line" | jq -r '.name')
            local host=$(echo "$line" | jq -r '.host')
            local user=$(echo "$line" | jq -r '.user')
            local port=$(echo "$line" | jq -r '.port // 22')
            local id=$(echo "$line" | jq -r '.id')

            printf "%-5s %-20s %-30s %-15s %-10s\n" "$index" "$name" "$host" "$user" "$port"
            ((index++))
        fi
    done < "$DATA_FILE"
    echo ""
}

# Add a new SSH connection
add_connection() {
    local name="$1"
    local host="$2"
    local user="$3"
    local port="${4:-22}"
    local identity_file="$5"
    local description="$6"

    ensure_data_file

    # Check if connection with same name exists
    if grep -q "\"name\":\"$name\"" "$DATA_FILE" 2>/dev/null; then
        echo "Error: Connection '$name' already exists."
        echo "Use '/ssh-edit' to modify it."
        return 1
    fi

    local id=$(generate_id)
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    local json=$(cat <<EOF
{
  "id": "$id",
  "name": "$name",
  "host": "$host",
  "user": "$user",
  "port": $port,
  "identity_file": $([ -n "$identity_file" ] && echo "\"$identity_file\"" || echo "null"),
  "description": $([ -n "$description" ] && echo "\"$description\"" || echo "null"),
  "created_at": "$timestamp",
  "updated_at": "$timestamp"
}
EOF
)

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
}

# Get connection by index (for edit/delete)
get_connection_by_index() {
    local index=$1
    local line_num=0

    ensure_data_file

    while IFS= read -r line; do
        if [ -n "$line" ]; then
            ((line_num++))
            if [ "$line_num" -eq "$index" ]; then
                echo "$line"
                return 0
            fi
        fi
    done < "$DATA_FILE"

    return 1
}

# Delete connection by index
delete_connection() {
    local index=$1
    local line_num=0
    local temp_file=$(mktemp)

    ensure_data_file

    while IFS= read -r line; do
        if [ -n "$line" ]; then
            ((line_num++))
            if [ "$line_num" -ne "$index" ]; then
                echo "$line" >> "$temp_file"
            else
                local name=$(echo "$line" | jq -r '.name')
                deleted_name="$name"
            fi
        fi
    done < "$DATA_FILE"

    mv "$temp_file" "$DATA_FILE"

    if [ -n "$deleted_name" ]; then
        echo "✓ SSH connection '$deleted_name' deleted successfully."
        return 0
    else
        echo "Error: Connection #$index not found."
        return 1
    fi
}

# Edit connection
edit_connection() {
    local index=$1
    shift
    local updates="$@"  # Expected format: "key=value key2=value2"

    ensure_data_file

    local line=$(get_connection_by_index "$index")
    if [ -z "$line" ]; then
        echo "Error: Connection #$index not found."
        return 1
    fi

    local temp_file=$(mktemp)
    local line_num=0
    local updated=false

    while IFS= read -r current_line; do
        if [ -n "$current_line" ]; then
            ((line_num++))
            if [ "$line_num" -eq "$index" ]; then
                # Update the line with new values
                local updated_line="$current_line"

                # Parse updates
                for update in $updates; do
                    local key=$(echo "$update" | cut -d'=' -f1)
                    local value=$(echo "$update" | cut -d'=' -f2-)

                    # Handle different field types
                    case "$key" in
                        port)
                            updated_line=$(echo "$updated_line" | jq --argjson v "$value" '.port = $v')
                            ;;
                        description|identity_file)
                            if [ "$value" = "null" ]; then
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
                echo "$current_line" >> "$temp_file"
            fi
        fi
    done < "$DATA_FILE"

    mv "$temp_file" "$DATA_FILE"

    if [ "$updated" = true ]; then
        echo "✓ SSH connection #$index updated successfully."
        echo ""
        echo "Updated connection:"
        get_connection_by_index "$index" | jq -r '"
  Name: \(.name)
  Host: \(.host)
  User: \(.user)
  Port: \(.port)
  \(.description // "Description: " + .description // "")
"'
        return 0
    else
        echo "Error: Failed to update connection."
        return 1
    fi
}

# Export functions
export -f list_connections
export -f add_connection
export -f delete_connection
export -f edit_connection
