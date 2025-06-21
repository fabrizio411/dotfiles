wifi() {
  local iface="wlp7s0"

  if [[ "$1" == "-l" ]]; then
    nmcli device wifi list

  elif [[ "$1" == "-d" ]]; then
    nmcli device disconnect "$iface"

  else
    if [[ -z "$1" ]]; then
      echo "Network missing"
      return 1
    fi

    local ssid="$1"
    local password="$2"

    # Buscar conexion guardada con SSID
    if nmcli connection show | awk '{print $1}' | grep -xq -- "$ssid"; then
      nmcli connection up "$ssid"
    else
      nmcli device wifi connect "$ssid" password "$password"
    fi
  fi
}

conf() {
  cd ~/.config || return 1
  nvim
}

gg() {
  local msg="${*:-Update}"
  ga
  gc "$msg"
  gp
}
