#!/bin/bash
# /* ---- Adaptado para Niri 💫 ---- */  ##
# Script para atualizar ags, waybar, rofi, swaync, wallust

SCRIPTSDIR="$HOME/.config/niri/scripts"
UserScripts="$HOME/.config/niri/UserScripts"

# Função: verificar se arquivo existe
file_exists() {
    if [ -e "$1" ]; then
        return 0
    else
        return 1
    fi
}

# Matar processos em execução
_ps=(waybar rofi swaync ags)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

# wallust às vezes não aplica cores -> sinal para waybar
killall -SIGUSR2 waybar 2>/dev/null

# Reiniciar ags
ags -q && ags &

# Enviar SIGUSR1 para alguns processos (forçar reload)
for pid in $(pidof waybar rofi swaync ags swaybg); do
    kill -SIGUSR1 "$pid"
done

# Restart waybar
sleep 1
waybar &

# Restart swaync
sleep 0.5
swaync > /dev/null 2>&1 &
swaync-client --reload-config

# Relançar rainbow borders se existir
sleep 1
if file_exists "${UserScripts}/RainbowBorders.sh"; then
    "${UserScripts}/RainbowBorders.sh" &
fi

exit 0
