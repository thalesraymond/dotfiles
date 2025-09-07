# Thales Raymond's Dotfiles

A comprehensive collection of personal configuration files (dotfiles) designed to create a stunning, efficient, and highly customized desktop experience on Linux. This setup is centered around the **Hyprland** compositor, **Waybar** status bar, and a suite of other powerful tools that work together to deliver a seamless and visually consistent workflow.

Whether you're a developer, a power user, or just someone who loves to tinker with their environment, these dotfiles provide a solid foundation for building your perfect desktop.

---

## 🌟 Features

- **Visually Stunning Themes**: A curated selection of themes for Waybar, Rofi, and other tools, with a focus on aesthetics and readability.
- **Dynamic & Informative Waybar**: Custom modules for everything from system resources (CPU, RAM, disk) and network status to media playback and workspace indicators.
- **Optimized Hyprland Configuration**: A finely-tuned Hyprland setup with smooth animations, intelligent window management, and a logical workspace layout.
- **Powerful Shell Experience**: A customized Zsh environment with useful aliases, functions, and a prompt that's both informative and stylish.
- **Effortless Management with GNU Stow**: Easily manage your dotfiles with GNU Stow, which creates symbolic links to keep your configurations in sync.
- **Script-Enhanced Functionality**: A collection of helper scripts to automate common tasks, such as changing themes, managing wallpapers, and more.

---

## 📦 What’s Inside

This repository is organized into the following directories, each containing the configuration for a specific tool:

- **`hypr/`**: Configuration files for the Hyprland compositor, including window rules, animations, and keybindings.
- **`waybar/`**: A collection of themes, modules, and styles for the Waybar status bar.
- **`rofi/`**: Themes and scripts for Rofi, a powerful application launcher and window switcher.
- **`zshrc/`**: The main configuration file for the Zsh shell, including aliases, environment variables, and prompt settings.
- **`gtk20/`, `gtk30/`, `gtk40/`**: GTK themes to ensure a consistent look and feel across all applications.
- **`.github/`**: Workflow files for automating tasks on GitHub, such as creating releases.
- **`scripts/`**: A variety of helper scripts to enhance the functionality of the desktop environment.

---

## 🚀 Quick Setup

There are two ways to install these dotfiles: using **GNU Stow** (recommended) or by manually creating symbolic links.

### Using GNU Stow (Recommended)

GNU Stow is a symlink farm manager that makes it easy to manage your dotfiles.

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/thalesraymond/dotfiles ~/dotfiles
    cd ~/dotfiles
    ```

2.  **Back up or remove your existing configurations:**

    ```bash
    # Example for backing up Waybar configuration
    mv ~/.config/waybar ~/.config/waybar.bak
    ```

3.  **Use Stow to deploy the configurations:**

    ```bash
    # Deploy Waybar configuration
    stow --target=$HOME/.config waybar

    # Deploy Hyprland configuration
    stow --target=$HOME/.config hypr

    # Deploy all configurations
    stow --target=$HOME .
    ```

### Manual Installation

If you prefer not to use Stow, you can manually create symbolic links to the configuration files.

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/thalesraymond/dotfiles ~/dotfiles
    cd ~/dotfiles
    ```

2.  **Create symbolic links:**

    ```bash
    # Example for Waybar
    ln -s ~/dotfiles/waybar/config ~/.config/waybar

    # Example for Hyprland
    ln -s ~/dotfiles/hypr/config ~/.config/hypr
    ```

---

## ⌨️ Keybindings

Here are some of the most important keybindings for Hyprland:

| Keybinding                | Action                                  |
| ------------------------- | --------------------------------------- |
| `Super + Enter`           | Open a new terminal (Ghostty)           |
| `Super + Q`               | Close the active window                 |
| `Super + D`               | Open the application launcher (Rofi)    |
| `Super + [1-9]`           | Switch to workspace 1-9                 |
| `Super + Shift + [1-9]`   | Move the active window to workspace 1-9 |
| `Super + H/J/K/L`         | Move focus between windows              |
| `Super + Shift + H/J/K/L` | Move the active window                  |

For a complete list of keybindings, please refer to the `hypr/configs/Keybinds.conf` file.

---

## 🙏 Credits

These dotfiles are a product of my own customization, but they are heavily inspired by the work of others in the Linux community. A special thanks to the creators of the following tools and themes:

- **Hyprland**: A dynamic tiling Wayland compositor.
- **Waybar**: A highly customizable Wayland bar for Sway and Wlroots-based compositors.
- **Rofi**: A window switcher, run launcher, and dmenu replacement.
- **Catppuccin Theme**: A soothing pastel theme for all the things.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
