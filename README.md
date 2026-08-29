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

## Media server (Docker Compose)

A self-hosted media automation stack lives in [`docker/media-server/`](docker/media-server/). It is **not** part of the Stow model (excluded via `docker/.stow-local-ignore`) — it is a standalone Docker Compose project running against the secondary HDD at `/mnt/media_storage`.

| Service     | Role | Port |
| ----------- | ---- | ---- |
| qBittorrent | Torrent client (WebUI) | 8080 (TCP + UDP `6881`) |
| FlareSolverr | Cloudflare challenge solver | internal (`http://flaresolverr:8191`) |
| Prowlarr    | Indexer manager | 9696 |
| Sonarr      | TV show automation | 8989 |
| Radarr      | Movie automation | 7878 |
| Bazarr      | Subtitle automation | 6767 |
| Maintainerr | Auto-cleanup rules (Jellyfin + *arrs) | 6246 |
| Jellyfin    | Media server (transcoding) | 8096 |

### Storage layout

```text
/mnt/media_storage
├── downloads/            # qBittorrent downloads (shared with Sonarr/Radarr)
└── media/
    ├── movies/           # Radarr-managed movies  → Jellyfin /data/movies
    └── tv/               # Sonarr-managed shows   → Jellyfin /data/tvshows
```

Initialize it (all containers run as `PUID=1000`/`PGID=1000`, so the HDD must be owned by UID/GID 1000):

```bash
sudo mkdir -p /mnt/media_storage/{downloads,media/movies,media/tv}
sudo chown -R 1000:1000 /mnt/media_storage
```

### Run the stack

```bash
cd docker/media-server
docker compose up -d        # stop with: docker compose down
```

- All services use `TZ=America/Sao_Paulo` and `restart: unless-stopped`.
- Downloads and media are on the **same filesystem**, so Sonarr/Radarr use hardlinks/atomic moves (no copy + delete). Point them at `http://qbittorrent:8080` on the compose network.
- **Bazarr** (subtitles): WebUI at `6767` → **Settings → Sonarr/Radarr**, add both apps. It mounts the same `/tv`/`/movies` paths, so no path mapping is needed.
- **FlareSolverr** (Cloudflare-protected indexers): in Prowlarr → **Settings → Indexers**, set the FlareSolverr API URL to `http://flaresolverr:8191`, then enable **Use FlareSolverr** on the affected indexers.
- **Maintainerr** (auto-cleanup): in its Settings, connect **Jellyfin** (`http://jellyfin:8096` + API key from Jellyfin → Dashboard → API Keys) and **Radarr/Sonarr** (API keys from their Settings → General). Media is mounted at the same `/tv`/`/movies` paths the *arrs report, so rules can delete files directly.
- Per-service config lives in `docker/media-server/config/` (gitignored) — back it up separately.

### Start on boot (optional)

```bash
sudo systemctl link ~/dotfiles/docker/media-server/media-server.service
sudo systemctl enable --now media-server.service
```

Edit `WorkingDirectory=` in the unit first if this repo is not at `~/dotfiles`. Containers also self-restart via their `restart:` policy should the Docker daemon restart.

### Jellyfin hardware acceleration (NVIDIA NVENC)

The compose file reserves the GPU for the `jellyfin` service via the NVIDIA container runtime — install the toolkit once on the host:

```bash
sudo pacman -S nvidia-container-toolkit     # Arch official repos
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

Then in Jellyfin → **Dashboard → Playback → Transcoding**, select **NVIDIA NVENC** and enable the codecs you want.

> **Run the stack on the native engine.** `docker compose` must use the `default` context (system Docker Engine), not Docker Desktop: Desktop runs its engine inside a VM that cannot see the host's `/dev/dri` or `/dev/nvidia*`, which fails with `error gathering device information while adding custom device "/dev/dri"`. The NVIDIA runtime is registered in `/etc/docker/daemon.json` for the native daemon only.
>
> ```bash
> docker context use default
> ```

On an Intel/AMD-only host, delete the `deploy:` GPU reservation and the `NVIDIA_*` environment variables from the `jellyfin` service, and add `devices: - /dev/dri:/dev/dri` for VAAPI/QSV.