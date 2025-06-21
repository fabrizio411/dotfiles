#!/bin/bash
# Versión que usa IDs en lugar de nombres para mayor precisión
# id-based-desktop-switch.sh

direction="$1"

# Usar IDs para mayor precisión
current_desktop_id=$(bspc query -D -d focused)
current_monitor_id=$(bspc query -M -d focused)

# Obtener todos los desktops del monitor actual (por ID)
desktop_ids=($(bspc query -D -m "$current_monitor_id"))

# Encontrar la posición del desktop actual
current_pos=-1
for i in "${!desktop_ids[@]}"; do
  if [[ "${desktop_ids[$i]}" == "$current_desktop_id" ]]; then
    current_pos=$i
    break
  fi
done

if [[ $current_pos -eq -1 ]]; then
  echo "Error: Desktop actual no encontrado"
  exit 1
fi

# Navegar usando IDs
case "$direction" in
"prev")
  if ((current_pos > 0)); then
    target_desktop_id="${desktop_ids[$((current_pos - 1))]}"
    bspc desktop -f "$target_desktop_id"
  fi
  ;;
"next")
  if ((current_pos < ${#desktop_ids[@]} - 1)); then
    target_desktop_id="${desktop_ids[$((current_pos + 1))]}"
    bspc desktop -f "$target_desktop_id"
  fi
  ;;
esac
