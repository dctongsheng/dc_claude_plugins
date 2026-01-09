# SSH Delete Command

Delete an SSH connection.

## Usage

```bash
/ssh-delete <index>
```

## Arguments

- `index` - Connection index number (use `/ssh-list` to find it)

## Examples

```bash
/ssh-delete 1
/ssh-delete 3
```

## Notes

- Use `/ssh-list` to find the connection index
- Deletion is permanent and cannot be undone
- The connection is immediately removed from `data/connections.jsonl`

## Example Workflow

```bash
# List connections
/ssh-list

# Delete connection #2
/ssh-delete 2

# Verify deletion
/ssh-list
```
