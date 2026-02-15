# Byte Pet

Byte Pet is a desktop robot companion that follows your cursor, animates while walking, and includes a built-in Ollama chat panel.

## Features

- Transparent desktop robot with idle/walk animations.
- Mouse-follow movement and directional body/head turning.
- Built-in customizer (look, scale, opacity, motion, animation).
- Terminal menu controls:
  - `1` / `toggle` to hide/show
  - `2` / `open` to open customizer
  - `3` / `quit` to exit
- Streaming chat via Ollama (`llama3.2:3b` by default).
- Optional robot voice replies.

## Important Files

- `install.sh` - Linux installer source with embedded app payload.
- `install.ps1` - self-contained Windows installer source with embedded app payload.
- `robot_pet_config.json` - settings file (optional; auto-copied on install if present).

## Quick Start (Windows)

`install.ps1` is self-contained and builds/installs `byte-pet.exe`.

1. Install Python 3 (with `venv` support).
2. From PowerShell in this folder, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

3. The installer will:
   - Install Byte Pet to `%LOCALAPPDATA%\byte-pet`
   - Automatically add `%LOCALAPPDATA%\byte-pet` to your user `PATH`
   - Open a new `cmd.exe` so `byte-pet` is available immediately

4. In the new `cmd` window, run:

```bat
byte-pet
```

If `byte-pet` is not found, run directly:

```bat
%LOCALAPPDATA%\byte-pet\byte-pet.exe
```

Optional Python override:

```bat
set BYTE_BUILD_PYTHON=C:\Path\To\python.exe && powershell -ExecutionPolicy Bypass -File .\install.ps1
```

## Quick Start (Linux)

`install.sh` builds a native executable for the current Linux system and installs it.

```bash
chmod +x install.sh
./install.sh
```

Then launch:

```bash
byte-pet
```

If not found:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Headless / VM / Codespaces (Linux)

When no GUI display is detected, the launcher can run Byte Pet in a virtual display and expose it via VNC/noVNC.

- Default behavior without `DISPLAY`/`WAYLAND_DISPLAY`: headless web mode is enabled.
- noVNC URL:
  - `http://localhost:6080/vnc.html?autoconnect=1&resize=scale`
- In Codespaces, forward port `6080` and open the forwarded URL.

Useful variables:

- `BYTE_HEADLESS_WEB=1` enable headless web mode.
- `BYTE_HEADLESS_WEB=0` disable it.
- `BYTE_WEB_PORT=6080` noVNC port.
- `BYTE_VNC_PORT=5901` VNC backend port.
- `BYTE_HEADLESS_DISPLAY=:99` virtual display id.
- `BYTE_XVFB_SCREEN=1280x800x24` virtual screen size/depth.

## Ollama Chat Setup

1. Install and run Ollama.
2. Ensure endpoint is reachable at `http://127.0.0.1:11434/api/chat`.
3. Installer/app use model `llama3.2:3b` by default.

Change endpoint:

```bash
export OLLAMA_CHAT_URL="http://127.0.0.1:11434/api/chat"
```

```powershell
$env:OLLAMA_CHAT_URL = "http://127.0.0.1:11434/api/chat"
```

Skip automatic model pull during install:

```bash
BYTE_SKIP_MODEL_PULL=1 ./install.sh
```

```bat
set BYTE_SKIP_MODEL_PULL=1 && powershell -ExecutionPolicy Bypass -File .\install.ps1
```

## Controls

- Left-drag Byte: move manually.
- Double left-click: pause/resume following.
- Right-click: open customizer.
- Keep terminal open to use the menu loop while app runs.

## Troubleshooting

- `install.ps1` blocked by execution policy:
  - Run: `powershell -ExecutionPolicy Bypass -File .\install.ps1`
- Python build errors on Windows:
  - Install Python 3 and rerun.
  - Set `BYTE_BUILD_PYTHON` to a known-good interpreter.
- `Ollama unavailable`:
  - Start Ollama and verify `http://127.0.0.1:11434` is reachable.
- No chat response:
  - `ollama list`
  - `ollama pull llama3.2:3b`
