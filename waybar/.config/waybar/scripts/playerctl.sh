#!/bin/bash
playerctl metadata --format '{{status}}|{{artist}} - {{title}}' 2>/dev/null | while IFS='|' read -r status info; do
  if [ "$status" = "Playing" ]; then
    echo "🎧 $info"
  else
    echo ""
  fi
done
