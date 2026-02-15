#!/usr/bin/env bash
set -euo pipefail

APP_ID="byte-pet"
APP_CMD="byte-pet"
MODEL_NAME="llama3.2:3b"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
APPS_DIR="$DATA_HOME/applications"
INSTALL_DIR="$DATA_HOME/$APP_ID"
VENV_DIR="$INSTALL_DIR/.venv"
LAUNCHER="$BIN_HOME/$APP_CMD"
DESKTOP_FILE="$APPS_DIR/$APP_ID.desktop"

if [[ -f "$SCRIPT_DIR/Byte.py" ]]; then
  APP_FILE="Byte.py"
elif [[ -f "$SCRIPT_DIR/byte.py" ]]; then
  APP_FILE="byte.py"
else
  echo "Error: Byte.py not found next to install.sh"
  exit 1
fi

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_system_packages() {
  if need_cmd apt-get; then
    if need_cmd sudo; then
      sudo apt-get update
      sudo apt-get install -y python3 python3-venv python3-tk xdotool espeak-ng
    else
      apt-get update
      apt-get install -y python3 python3-venv python3-tk xdotool espeak-ng
    fi
  elif need_cmd dnf; then
    if need_cmd sudo; then
      sudo dnf install -y python3 python3-pip python3-tkinter xdotool espeak-ng
    else
      dnf install -y python3 python3-pip python3-tkinter xdotool espeak-ng
    fi
  elif need_cmd pacman; then
    if need_cmd sudo; then
      sudo pacman -Sy --noconfirm python python-pip tk xdotool espeak-ng
    else
      pacman -Sy --noconfirm python python-pip tk xdotool espeak-ng
    fi
  elif need_cmd zypper; then
    if need_cmd sudo; then
      sudo zypper --non-interactive install python3 python3-pip python3-tk xdotool espeak-ng
    else
      zypper --non-interactive install python3 python3-pip python3-tk xdotool espeak-ng
    fi
  else
    echo "Warning: unsupported package manager. Install manually: python3 python3-venv python3-tk xdotool espeak-ng"
  fi
}

echo "[1/6] Installing system packages (if possible)..."
install_system_packages || true

echo "[2/6] Creating install directories..."
mkdir -p "$INSTALL_DIR" "$BIN_HOME" "$APPS_DIR"

echo "[3/6] Copying app files..."
cp "$SCRIPT_DIR/$APP_FILE" "$INSTALL_DIR/$APP_FILE"
if [[ -f "$SCRIPT_DIR/robot_pet_config.json" ]]; then
  cp "$SCRIPT_DIR/robot_pet_config.json" "$INSTALL_DIR/robot_pet_config.json"
fi

echo "[4/6] Creating virtual environment..."
python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/python" -m pip install --upgrade pip >/dev/null

echo "[5/6] Creating launcher..."
cat > "$LAUNCHER" <<EOF
#!/usr/bin/env bash
set -euo pipefail
exec "$VENV_DIR/bin/python" "$INSTALL_DIR/$APP_FILE" "\$@"
EOF
chmod +x "$LAUNCHER"

echo "[6/6] Creating desktop entry..."
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Byte Pet
Comment=Desktop robot pet companion
Exec=$LAUNCHER
Terminal=true
Categories=Utility;
EOF

if need_cmd update-desktop-database; then
  update-desktop-database "$APPS_DIR" >/dev/null 2>&1 || true
fi

if need_cmd ollama; then
  echo "Pulling Ollama model: $MODEL_NAME"
  ollama pull "$MODEL_NAME" || echo "Warning: could not pull $MODEL_NAME"
else
  echo "Ollama not found. Install Ollama manually if chat is needed."
fi

echo
echo "Install complete."
echo "Run with: $APP_CMD"
echo "If command not found, add this to your shell rc:"
echo "export PATH=\"$BIN_HOME:\$PATH\""
