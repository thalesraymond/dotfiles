# My Dotfiles

This repository contains my personal dotfiles for a Linux desktop environment. The setup is centered around Hyprland, DankMaterialShell, and a dynamic, wallpaper-based theming system.

## Management

These dotfiles are managed using [GNU Stow](https://www.gnu.org/software/stow/). To deploy them, clone this repository and then use `stow` to create symbolic links. For example, to deploy the `hypr` configuration, you would run:

```bash
stow hypr
```

To stow all configurations, you can run:
```bash
stow */
```
**Note:** The `*/` does not work on zsh, you need to use `stow *` instead.

## Core Components

This setup is built on a few key pieces of software that integrate to create a cohesive desktop experience.

### Window Compositor

*   **[Hyprland](https://hyprland.org/):** A dynamic tiling Wayland compositor. It is the primary compositor for this setup.
*   **[Niri](https://github.com/YaLTeR/niri):** An alternative, scrollable-tiling Wayland compositor. Configurations are also included for Niri.

### Desktop Shell

*   **[DankMaterialShell (DMS)](https://github.com/danklammer/dank-material-shell):** This is the heart of the desktop UI. It provides the top status bar, widgets, notifications, and the control center. It also orchestrates the system-wide theming.

### Dynamic Theming

The visual theme is generated on-the-fly from your current wallpaper.

*   **[Matugen](https://github.com/InioX/matugen):** This tool generates a Material You color palette from an image.
*   **DankMaterialShell Integration:** DMS uses `matugen` to create a theme from the wallpaper and then applies it across the system. It uses a template system to update the configuration files for various applications with the new color scheme.

## Configured Applications

The theming system applies to a variety of applications, ensuring a consistent look and feel. Configurations are included for:

*   **Terminal:** Kitty
*   **Application Launcher:** Rofi
*   **GTK:** GTK2, GTK3, and GTK4 themes
*   **Waybar:** While DMS provides the main bar, Waybar configs are also present.
*   **And more...**

## Package Installation

To replicate this setup, you can use the provided package lists:

*   `pkglist.txt`: A list of official Arch Linux repository packages.
*   `aurlist.txt`: A list of packages from the Arch User Repository (AUR).

You can install them using an AUR helper like `yay` or `paru`:

```bash
# pacman packages
sudo pacman -S --needed - < pkglist.txt

# AUR packages
yay -S --needed - < aurlist.txt
```