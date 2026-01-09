# {{Plugin Name}}

{{Plugin description}}

## Features

### Skills

- `{{/skill-name}}` - {{Skill description}}

### Commands

- `{{/command-name}}` - {{Command description}}

### Hooks

- `{{EventName}}` - {{Hook description}}

## Installation

```bash
cc --plugin-dir /workspace/xm/claude-plugins/plugins/{{plugin-name}}
```

Or install from marketplace:

```bash
/plugin install {{plugin-name}}@claude-plugins
```

## Usage

### Using Skills

Simply describe what you want in natural language:

```
{{Example user input}}
```

### Using Commands

```bash
{{/command-name}}
```

## Development

### Adding New Skills

1. Create a new `.md` file in the `skills/` directory
2. The filename becomes the skill name (e.g., `my-skill.md` -> `/my-skill`)
3. Write the skill prompt in Markdown

### Adding New Commands

1. Create a new `.md` file in the `commands/` directory
2. Document the command usage and behavior

### Adding Hooks

Edit `hooks/hooks.json` to add new hook configurations.

## License

MIT
