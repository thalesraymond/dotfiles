# Dotfiles

My personal Linux desktop configuration files, managed with GNU Stow.

## Components overview

- **Compositors:** [Hyprland](https://hyprland.org/) (primary) and [Niri](https://github.com/YaLTeR/niri)
- **Desktop Shell & UI:** [DankMaterialShell](https://github.com/danklammer/dank-material-shell), Waybar, Rofi, Quickshell
- **Terminals:** Kitty, Ghostty
- **Theming:** Dynamic wallpaper-based material theming using Matugen and Wallust, with support for GTK applications
- **Other utilities:** Zsh, VS Code, Swaylock

## How to replicate

1. **Install dependencies:**
   The required packages are listed in `pkglist.txt` (Arch official repos) and `aurlist.txt` (AUR). Install them using pacman and an AUR helper (e.g., yay or paru):

   ```bash
   sudo pacman -S --needed - < pkglist.txt
   yay -S --needed - < aurlist.txt
   ```

2. **Clone the repository:**
   ```bash
   git clone https://github.com/thalesraymond/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

3. **Deploy configurations:**
   Use GNU Stow to create symbolic links in your home directory. To deploy all configurations:

   ```bash
   stow *
   ```
   *(Note: To stow individual components, specify the folder name, e.g., `stow hypr`)*