#!/bin/bash
# Función para cambiar entre monitores conectados - VERSIÓN CORREGIDA

# Listar monitores conectados según xrandr
connected_monitors=($(xrandr --query | grep " connected" | cut -d" " -f1))

# Verificar que hay más de un monitor conectado
if [[ ${#connected_monitors[@]} -lt 2 ]]; then
  echo "Solo hay un monitor conectado. No se puede cambiar."
  exit 0
fi

# Obtener el nombre del monitor enfocado actualmente (no el ID)
current_monitor_name=$(bspc query -M -m focused --names)

echo "Monitor actual: $current_monitor_name"
echo "Monitores conectados: ${connected_monitors[*]}"

# Buscar índice del monitor actual en la lista de conectados
current_index=-1
for i in "${!connected_monitors[@]}"; do
  if [[ "${connected_monitors[$i]}" == "$current_monitor_name" ]]; then
    current_index=$i
    break
  fi
done

# Si no encontramos el monitor actual en la lista (no debería pasar)
if [[ $current_index -eq -1 ]]; then
  echo "Error: Monitor actual no encontrado en lista de conectados"
  # Como fallback, ir al primer monitor conectado
  bspc monitor -f "${connected_monitors[0]}"
  exit 0
fi

# Cambiar al siguiente monitor conectado (en ciclo)
next_index=$(((current_index + 1) % ${#connected_monitors[@]}))
next_monitor="${connected_monitors[$next_index]}"

echo "Cambiando a: $next_monitor"
bspc monitor -f "$next_monitor"
