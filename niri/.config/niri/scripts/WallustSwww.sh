#!/bin/bash
# /* ---- 💫 Adaptado para Niri 💫 ---- */  ##
# Wallust: derive colors from the current wallpaper and update templates
# Uso: WallustNiri.sh [caminho_absoluto_para_wallpaper]

set -euo pipefail

# Inputs e paths
passed_path="${1:-}"
cache_dir="$HOME/.cache/swww/"
rofi_link="$HOME/.config/rofi/.current_wallpaper"
wallpaper_current="$HOME/.config/niri/wallpaper_effects/.wallpaper_current"

# Helper: pegar o monitor focado no Niri
get_focused_monitor() {
  if command -v jq >/dev/null 2>&1; then
    #niri msg focused-output | jq -r 'match("\\(([^)]+)\\)").captures[0].string'
    niri msg focused-output | grep -oP '\(\K[^)]+' | head -n1
  else
    niri msg focused-output | grep -oP '\(\K[^)]+' | head -n1
  fi
}

# Determinar wallpaper_path
wallpaper_path=""
if [[ -n "$passed_path" && -f "$passed_path" ]]; then
  wallpaper_path="$passed_path"
else
  # tenta pegar do cache do swww para o monitor focado
  current_monitor="$(get_focused_monitor)"
  cache_file="$cache_dir$current_monitor"

  # aguarda o swww atualizar o cache
  for i in {1..10}; do
    if [[ -f "$cache_file" ]]; then
      break
    fi
    sleep 0.1
  done

  if [[ -f "$cache_file" ]]; then
    wallpaper_path="$(grep -v 'Lanczos3' "$cache_file" | head -n1)"
  fi
fi

if [[ -z "${wallpaper_path:-}" || ! -f "$wallpaper_path" ]]; then
  # nada a fazer
  exit 0
fi

# Atualizar symlinks e cópias
ln -sf "$wallpaper_path" "$rofi_link" || true
mkdir -p "$(dirname "$wallpaper_current")"
cp -f "$wallpaper_path" "$wallpaper_current" || true

# Rodar wallust para regenerar templates
wallust run -s "$wallpaper_path" || true
