# SSH List Command

List all SSH connections.

## Usage

```bash
/ssh-list
```

## Description

Displays all saved SSH connections in a formatted table showing:
- Index number (for edit/delete operations)
- Connection name
- Host address
- Username
- Port

## Examples

```bash
/ssh-list
```

Output:
```
SSH Connections:

ID    Name                 Host                           User            Port
------------------------------------------------------------------------------------------------
1     production-server    prod.example.com               admin           22
2     staging-db           staging.db.example.com          dbuser          22
3     localhost            127.0.0.1                       root            2222
```

## Notes

- Use the index number with `/ssh-edit` and `/ssh-delete` commands
- Connections are stored in JSONL format in `data/connections.jsonl`
