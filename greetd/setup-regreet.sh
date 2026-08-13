#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing greetd + greetd-regreet"
sudo pacman -S --needed greetd greetd-regreet

echo "==> Setting up /var/lib/regreet-bg"
sudo mkdir -p /var/lib/regreet-bg
sudo chown luis:luis /var/lib/regreet-bg
sudo chmod 755 /var/lib/regreet-bg

echo "==> Writing /etc/greetd/config.toml"
sudo tee /etc/greetd/config.toml > /dev/null <<'EOF'
[terminal]
vt = 1

[default_session]
command = "regreet"
user = "greeter"
EOF

echo "==> Writing /etc/greetd/regreet.toml"
sudo tee /etc/greetd/regreet.toml > /dev/null <<'EOF'
skip_selection = false

[background]
path = "/var/lib/regreet-bg/background.png"
fit = "Cover"

[GTK]
application_prefer_dark_theme = true
cursor_theme_name = "Breeze"
cursor_blink = true
font_name = "Noto Sans 14"

[commands]
reboot = ["systemctl", "reboot"]
poweroff = ["systemctl", "poweroff"]

[appearance]
greeting_msg = ""

[widget.clock]
format = "%H:%M"
EOF

echo "==> Writing /etc/greetd/regreet.css"
sudo tee /etc/greetd/regreet.css > /dev/null <<'EOF'
window {
  background-color: transparent;
}

.background {
  background-color: rgba(20, 20, 24, 0.55);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 18px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35);
}

.background > label {
  font-size: 28pt;
  font-weight: 600;
  color: #ffffff;
  padding: 6px 24px;
}

entry, password-entry {
  border-radius: 10px;
  min-height: 36px;
  padding: 4px 10px;
}

button {
  border-radius: 10px;
  min-height: 36px;
  padding: 4px 16px;
}

button.suggested-action {
  background-color: #7aa2f7;
  color: #101014;
  font-weight: 600;
}

button.suggested-action:hover {
  background-color: #93b4fa;
}

button.destructive-action {
  background-color: rgba(255, 255, 255, 0.08);
  color: #f7768e;
}

button.destructive-action:hover {
  background-color: rgba(247, 118, 142, 0.18);
}
EOF

echo "==> Removing stale pacsave leftover"
sudo rm -f /etc/greetd/config.toml.pacsave

echo "==> Verifying configs parse as valid TOML"
python3 -c "import tomllib; tomllib.load(open('/etc/greetd/config.toml','rb')); print('config.toml OK')"
python3 -c "import tomllib; tomllib.load(open('/etc/greetd/regreet.toml','rb')); print('regreet.toml OK')"

echo "==> Switching display manager: lightdm -> greetd (takes effect next boot/logout, not immediately)"
sudo systemctl disable lightdm
sudo systemctl enable greetd

echo ""
echo "==> Done. Do NOT log out or reboot yet."
echo "    Tell Claude you ran this so it can seed the background image and do final checks first."
