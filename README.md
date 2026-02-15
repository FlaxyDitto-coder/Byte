# Byte Pet

Byte Pet is a desktop robot companion that follows your cursor, animates while walking, and includes a built-in chat panel powered by Ollama.

## Features

- Transparent desktop robot window with motion and idle/walk animations.
- Robot tracks the mouse cursor and rotates body/head direction while moving.
- Terminal control menu loop:
  - `1` / `toggle` to hide/show the pet
  - `2` / `open` to open customizer
  - `3` / `quit` to exit
- Customizer GUI with options for look, size, opacity, movement, and animation behavior.
- Chat tab with streaming responses from Ollama (`llama3.2:3b` by default).
- Optional robot TTS for replies.

## Distributed Files

- `Byte.exe` - Windows app
- `install.sh` - Linux installer
- `robot_pet_config.json` - saved settings

## Quick Start (Windows)

1. Keep `Byte.exe` and `robot_pet_config.json` in the same folder.
2. Run `Byte.exe`.

## Quick Start (Linux)

```bash
chmod +x install.sh
./install.sh
```

Then launch:

```bash
byte-pet
```

If `byte-pet` is not found, add this to your shell profile:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Ollama Chat Setup

1. Install and run Ollama.
2. Ensure endpoint is reachable at `http://127.0.0.1:11434/api/chat`.
3. The app uses model `llama3.2:3b` and will try to pull it if missing.

To use a different endpoint:

```bash
export OLLAMA_CHAT_URL="http://127.0.0.1:11434/api/chat"
```

PowerShell:

```powershell
$env:OLLAMA_CHAT_URL = "http://127.0.0.1:11434/api/chat"
```

## Mouse + App Controls

- Left mouse drag on Byte: move Byte manually.
- Double left click on Byte: pause/resume following.
- Right click on Byte: open customizer.
- Keep terminal open to use menu commands while app runs.

## Notes

- Chat streaming is enabled.
- Settings are saved in `robot_pet_config.json`.
- On non-Windows systems, speech output may depend on system voice tools.

## Troubleshooting

- `Ollama unavailable`:
  - Start Ollama service and confirm `http://127.0.0.1:11434` is reachable.
- No chat response:
  - Check model availability: `ollama list`
  - Pull model manually: `ollama pull llama3.2:3b`
- `byte-pet: command not found` (Linux):
  - Add `~/.local/bin` to `PATH` and restart shell.
