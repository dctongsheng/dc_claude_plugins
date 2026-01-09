# SSH Add Command

Add a new SSH connection.

## Usage

```bash
/ssh-add <name> <host> <user> [port] [identity_file] [description]
```

## Arguments

- `name` - Connection name (required, must be unique)
- `host` - Host address or IP (required)
- `user` - SSH username (required)
- `port` - SSH port (optional, default: 22)
- `identity_file` - Path to SSH private key (optional)
- `description` - Connection description (optional)

## Examples

```bash
# Basic connection
/ssh-add production prod.example.com admin

# Connection with custom port
/ssh-add production prod.example.com admin 2222

# Connection with identity file
/ssh-add github github.com gituser 22 ~/.ssh/id_rsa

# Connection with all fields
/ssh-add production prod.example.com admin 22 ~/.ssh/id_rsa "Production server"
```

## Notes

- Connection names must be unique
- Default port is 22 if not specified
- Identity file path is optional (uses default SSH agent if not specified)
- All connections are saved to `data/connections.jsonl`
