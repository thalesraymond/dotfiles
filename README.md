# 🌌 Thales' Waybar + Hyprland Dotfiles

Custom configuration files for [Waybar](https://github.com/Alexays/Waybar) and [Hyprland](https://github.com/hyprwm/Hyprland), optimized for performance, ricing, and modularity. Built with [GNU Stow](https://www.gnu.org/software/stow/) for clean management.

> ⚙️ Based on the [Hyprkool](https://github.com/thrombe/hyprkool) starter pack

---

## 📦 Features

- ✨ Beautiful **custom Waybar themes** (Cyberpunk, Zen Dark, HUD, and more)
- 🧱 Hyprland workspace & window support
- 📊 Modules: CPU, RAM, Disk, Volume, Network, Visualizer, etc.
- 🎛️ Easy configuration via [GNU Stow](https://www.gnu.org/software/stow/)
- 🔮 Transparent, blur-friendly, themed CSS
- ⚙️ Shell scripts for dynamic modules (`glitch.sh`, `net_status`, etc.)

---

## 🚀 Initial Setup

> These steps assume you're starting from a fresh HyprKool-based setup.

### ✅ 1. Pre-requisites

Make sure you have:

- Hyprland (recommended: HyprKool)
- Waybar
- Nerd Font (e.g. [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads))
- `swaybg` or `swww` for wallpapers (optional)
- [GNU Stow](https://www.gnu.org/software/stow/) installed:

```bash
sudo dnf install stow   # Fedora
sudo pacman -S stow     # Arch
```

---

## 📁 Repo Structure

```
dotfiles/
├── waybar/
│   ├── config.jsonc         # Waybar config
│   ├── style.css            # Main style sheet
│   └── scripts/             # Custom shell scripts for modules
├── hypr/                    # (optional) Hyprland config
├── ...
```

---

## 📂 Installation with GNU Stow

> Run these commands from the root of this repo:

### 🛠️ Step-by-step:

```bash
# Clone the dotfiles
git clone https://github.com/thalesraymond/dotfiles ~/dotfiles
cd ~/dotfiles

# Clean up any existing config (optional, careful!)
rm -rf ~/.config/waybar

# Stow the Waybar files into place
stow --target=$HOME/.config waybar
```

📌 If you're also using the `hypr/` directory:
```bash
stow --target=$HOME/.config hypr
```

---

## 🧪 Optional: Scripts

Some modules rely on shell scripts inside `waybar/scripts/`:

| Script        | Purpose                           |
|---------------|-----------------------------------|
| `glitch.sh`   | Rotating terminal-style messages  |
| `net_status`  | Show ✓ or ✗ based on connectivity |

Make sure scripts are executable:

```bash
chmod +x ~/.config/waybar/scripts/*.sh
```

---

## 💬 Contributing

Pull requests and suggestions welcome. If you have an idea for a new theme, feel free to fork and submit it!

---

## 📸 Screenshots

> *maybe another time*

## 📚 Credits

- [Waybar](https://github.com/Alexays/Waybar)
- [Hyprland](https://github.com/hyprwm/Hyprland)
- [HyprKool](https://github.com/hyprwm/HyprKool)
- [Catppuccin](https://github.com/catppuccin)

---

## 🧠 License

MIT — use freely, but credits are appreciated.
