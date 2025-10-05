#!/bin/bash
# /* ---- Adaptado para Niri 💫 ---- */
# Script para selecionar wallpapers (SUPER W)

# WALLPAPERS PATH
terminal=kitty
wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/niri/scripts"
wallpaper_current="$HOME/.config/niri/wallpaper_effects/.wallpaper_current"

# Diretórios para swaync
iDIR="$HOME/.config/swaync/images"
iDIRi="$HOME/.config/swaync/icons"

# Config do swww (transição)
FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Verifica se bc existe
if ! command -v bc &>/dev/null; then
  notify-send -i "$iDIR/error.png" "bc missing" "Install package bc first"
  exit 1
fi

# Variáveis
rofi_theme="$HOME/.config/rofi/config-wallpaper.rasi"
focused_monitor=$(niri msg focused-output | grep "Output" | sed -E 's/.*\((.*)\)/\1/')

# Garantir que monitor foi detectado
if [[ -z "$focused_monitor" ]]; then
  notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Could not detect focused monitor"
  exit 1
fi

# Monitor details (ajustes de ícones do rofi)
scale_factor=1
monitor_height=1080
icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

# Funções para matar daemons
kill_wallpaper_for_video() {
  swww kill 2>/dev/null
  pkill mpvpaper 2>/dev/null
  pkill swaybg 2>/dev/null
  pkill hyprpaper 2>/dev/null
}

kill_wallpaper_for_image() {
  pkill mpvpaper 2>/dev/null
  pkill swaybg 2>/dev/null
  pkill hyprpaper 2>/dev/null
}

# Buscar imagens e vídeos
mapfile -d '' PICS < <(find -L "${wallDIR}" -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o \
  -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" -o \
  -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.webm" \) -print0)

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi
rofi_command="rofi -i -show -dmenu -config $rofi_theme -theme-str $rofi_override"

# Menu (sorted + previews)
menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))

  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"

  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    if [[ "$pic_name" =~ \.gif$ ]]; then
      cache_gif_image="$HOME/.cache/gif_preview/${pic_name}.png"
      if [[ ! -f "$cache_gif_image" ]]; then
        mkdir -p "$HOME/.cache/gif_preview"
        magick "$pic_path[0]" -resize 1920x1080 "$cache_gif_image"
      fi
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_gif_image"
    elif [[ "$pic_name" =~ \.(mp4|mkv|mov|webm)$ ]]; then
      cache_preview_image="$HOME/.cache/video_preview/${pic_name}.png"
      if [[ ! -f "$cache_preview_image" ]]; then
        mkdir -p "$HOME/.cache/video_preview"
        ffmpeg -v error -y -i "$pic_path" -ss 00:00:01.000 -vframes 1 "$cache_preview_image"
      fi
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_preview_image"
    else
      printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
    fi
  done
}

# Aplicar wallpaper (imagem)
apply_image_wallpaper() {
  local image_path="$1"

  kill_wallpaper_for_image

  if ! pgrep -x "swww-daemon" >/dev/null; then
    echo "Starting swww-daemon..."
    swww-daemon --format xrgb &
  fi

  swww img -o "$focused_monitor" "$image_path" $SWWW_PARAMS

  # Run wallust + refresh
  "$SCRIPTSDIR/WallustSwww.sh"
  sleep 2
  "$SCRIPTSDIR/Refresh.sh"
  sleep 1
}

# Aplicar wallpaper (vídeo)
apply_video_wallpaper() {
  local video_path="$1"

  if ! command -v mpvpaper &>/dev/null; then
    notify-send -i "$iDIR/error.png" "E-R-R-O-R" "mpvpaper not found"
    return 1
  fi
  kill_wallpaper_for_video

  mpvpaper '*' -o "load-scripts=no no-audio --loop" "$video_path" &
}

# Main
main() {
  choice=$(menu | $rofi_command)
  choice=$(echo "$choice" | xargs)
  RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

  if [[ -z "$choice" ]]; then
    echo "No choice selected. Exiting."
    exit 0
  fi

  if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
    choice=$(basename "$RANDOM_PIC")
  fi

  choice_basename=$(basename "$choice" | sed 's/\(.*\)\.[^.]*$/\1/')

  selected_file=$(find "$wallDIR" -iname "$choice_basename.*" -print -quit)

  if [[ -z "$selected_file" ]]; then
    echo "File not found. Selected choice: $choice"
    exit 1
  fi

  if [[ "$selected_file" =~ \.(mp4|mkv|mov|webm)$ ]]; then
    apply_video_wallpaper "$selected_file"
  else
    apply_image_wallpaper "$selected_file"
  fi
}

# Evita múltiplas instâncias do rofi
if pidof rofi >/dev/null; then
  pkill rofi
fi

main
