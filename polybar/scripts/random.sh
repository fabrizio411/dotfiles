#!/usr/bin/env bash

# Color files
PFILE="$HOME/.config/polybar/colors.ini"
RFILE="$HOME/.config/polybar/scripts/rofi/colors.rasi"

# Change colors
change_color() {
  # polybar
  sed -i -e "s/background = #.*/background = #${BG}/g" $PFILE
  sed -i -e "s/background-alt = #.*/background-alt = #8C${BG}/g" $PFILE
  sed -i -e "s/foreground = #.*/foreground = #${FG}/g" $PFILE
  sed -i -e "s/foreground-alt = #.*/foreground-alt = #33${FG}/g" $PFILE
  sed -i -e "s/primary = #.*/primary = $AC/g" $PFILE

  # rofi
  cat >$RFILE <<-EOF
	/* colors */

	* {
	  al:   #00000000;
	  bg:   #${BG}BF;
	  bga:  #${BG}FF;
	  fg:   #${FG}FF;
	  ac:   ${AC}FF;
	  se:   ${AC}1A;
	}
	EOF

  polybar-msg cmd restart
}

get_random_number() {
  RNUM=$((($RANDOM % $1) + 1))
}

get_random_color() {
  RCOLOR="#"
  for i in 1 2 3 4 5 6; do
    get_random_number "16"
    case $RNUM in
    "1") NEXTDIGIT="1" ;;
    "2") NEXTDIGIT="2" ;;
    "3") NEXTDIGIT="3" ;;
    "4") NEXTDIGIT="4" ;;
    "5") NEXTDIGIT="5" ;;
    "6") NEXTDIGIT="6" ;;
    "7") NEXTDIGIT="7" ;;
    "8") NEXTDIGIT="8" ;;
    "9") NEXTDIGIT="9" ;;
    "10") NEXTDIGIT="A" ;;
    "11") NEXTDIGIT="B" ;;
    "12") NEXTDIGIT="C" ;;
    "13") NEXTDIGIT="D" ;;
    "14") NEXTDIGIT="E" ;;
    "15") NEXTDIGIT="F" ;;
    "16") NEXTDIGIT="0" ;;
    esac
    RCOLOR="$RCOLOR$NEXTDIGIT"
  done
  echo $RCOLOR
}

hex_to_rgb() {
  # Convert a hex value WITHOUT the hashtag (#)
  R=$(printf "%d" 0x${1:0:2})
  G=$(printf "%d" 0x${1:2:2})
  B=$(printf "%d" 0x${1:4:2})
}

get_fg_color() {
  INTENSITY=$(calc "$R*0.299 + $G*0.587 + $B*0.114")

  if [ $(echo "$INTENSITY>186" | bc) -eq 1 ]; then
    FG="0a0a0a"
    AC="#0a0a0a"
  else
    FG="F5F5F5"
    AC="#F5F5F5"
  fi
}

# Main
BGC=$(get_random_color)
BG=${BGC:1}
HEX=$BG

hex_to_rgb $HEX
get_fg_color
change_color
