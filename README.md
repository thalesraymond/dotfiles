# thalesraymond/dotfiles

A personal collection of configuration files ("dotfiles") for customizing my desktop setup—specifically targeting Hyprland, Waybar, and shell enhancements.

---

##  What’s Inside

- **waybar/** – Custom themes and modules for Waybar (e.g., Cyberpunk, Zen Dark, HUD).
- **hypr/** – Configurations for the Hyprland compositor (workspace/window setup, appearance tweaks).
- **zshrc** – Shell initialization file—aliases, environment, prompt, and related preferences.
- **.config/** – Configuration directories following XDG standards.
- **Screenshots** – Visual examples of the setup in action (e.g., `Screenshot_…png`).

---

## Features at a Glance

- Stylish and functional Waybar themes.
- Workspaces and layout tailored for Hyprland.
- Dynamic modules: CPU, RAM, Disk, Network, Volume, Visualizer, etc.
- Organized setup using GNU Stow (recommended) or manual symlinks.
- Includes shell scripts (e.g. `glitch.sh`, `net_status`) to enhance functionality.

---

##  Quick Setup (GNU Stow)

```bash
# Clone this repo
git clone https://github.com/thalesraymond/dotfiles ~/dotfiles
cd ~/dotfiles

# Optional: backup or remove existing config
rm -rf ~/.config/waybar ~/.config/hypr ~/.zshrc

# Use stow to deploy configurations
stow --target=$HOME/.config waybar
stow --target=$HOME/.config hypr
