# brightness.nix
{ pkgs, ... }:
pkgs.writeShellScriptBin "brightness-control" ''
  #!${pkgs.bash}/bin/bash

  bar_color="#61afef"

  function help {
  cat << EOF
  -h: wyswietl ten message
  -a {step} podnies jasnosc
  -d {step} zmniejsz jasnosc
  EOF
  }

  function get_brightness {
    ${pkgs.brightnessctl}/bin/brightnessctl i | ${pkgs.gnugrep}/bin/grep -i current | ${pkgs.coreutils}/bin/cut -d'(' -f2 | ${pkgs.coreutils}/bin/tr -d '%)'
  }

  function set_brightness {
    ${pkgs.brightnessctl}/bin/brightnessctl s "$1"
  }

  function show_notify {
    volume="$1"
    volume_icon="$2"
    ${pkgs.dunst}/bin/dunstify -i audio-volume-muted-blocking -t 1000 -r 2593 -u normal "$volume_icon $volume%" -h int:value:"$volume" -h string:hlcolor:$bar_color
  }

  brightness_percentage=$(get_brightness)

  if [[ -z "$brightness_percentage" ]]; then
    echo "could not get brightness"
    exit 1
  fi

  while getopts "h:a:d:" option; do
    case "$option" in
      h)
        help
        exit;;
      a)
        set_brightness "+$OPTARG%"
        show_notify "$(get_brightness)" "󱩕"
        exit;;
      d)
        if [[ $((brightness_percentage - OPTARG)) -lt 5 ]]; then
          set_brightness 5
          show_notify "$(get_brightness)" "󱩕"
          echo "Brightness is at its lowest"
          exit 0
        fi
        set_brightness "$OPTARG%-"
        show_notify "$(get_brightness)" "󱩏"
        exit;;
      \?)
        echo invalid option
        show_notify "$(get_brightness)" "󰌵"
        exit;;
    esac
  done
''
