# SSH Edit Command

Edit an existing SSH connection.

## Usage

```bash
/ssh-edit <index> <field>=<value> [<field>=<value> ...]
```

## Arguments

- `index` - Connection index number (use `/ssh-list` to find it)
- `field=value` - Field to update (can specify multiple)

## Available Fields

- `name` - Connection name
- `host` - Host address
- `user` - Username
- `port` - Port number
- `identity_file` - Path to SSH private key
- `description` - Connection description

## Examples

```bash
# Update host
/ssh-edit 1 host=prod2.example.com

# Update multiple fields
/ssh-edit 1 host=new.example.com port=2222

# Update description
/ssh-edit 1 description="Updated production server"

# Remove identity file
/ssh-edit 1 identity_file=null

# Update name and user
/ssh-edit 1 name=production-new user=admin2
```

## Notes

- Use `/ssh-list` to find the connection index
- Multiple fields can be updated in one command
- Set a field to `null` to remove it (for optional fields like identity_file or description)
- The `updated_at` timestamp is automatically updated
