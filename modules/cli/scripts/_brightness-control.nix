{ pkgs, ... }:
pkgs.writeShellScriptBin "brightness" ''
  bar_color="#61afef"
  LAPTOP_BACKLIGHT="/sys/class/backlight/amdgpu_bl1"
  monitors=($(systemctl list-units | grep -o "i2c-[0-9]*" | cut -d'-' -f2))
  MONITOR1_DDC="''${monitors[0]}"
  MONITOR2_DDC="''${monitors[1]}"

  function help {
  cat << EOF
  -h: show this message
  -a {step}: increase brightness (laptop-led, monitors follow)
  -d {step}: decrease brightness (laptop-led, monitors follow)
  EOF
  }

  function get_laptop_brightness {
    cat "$LAPTOP_BACKLIGHT/brightness"
  }

  function get_laptop_max_brightness {
    cat "$LAPTOP_BACKLIGHT/max_brightness"
  }

  function get_laptop_percentage {
    local current=$(get_laptop_brightness)
    local max=$(get_laptop_max_brightness)
    echo $((current * 100 / max))
  }

  function set_external_monitors {
    local percentage=$1
    ${pkgs.ddcutil}/bin/ddcutil -b $MONITOR1_DDC setvcp 10 "$percentage"
    ${pkgs.ddcutil}/bin/ddcutil -b $MONITOR2_DDC setvcp 10 "$percentage"
  }

  function set_brightness {
    local percentage=$1
    local max=$(get_laptop_max_brightness)
    local laptop_val=$((max * percentage / 100))

    # Set laptop brightness first
    echo "$laptop_val" | sudo ${pkgs.coreutils}/bin/tee "$LAPTOP_BACKLIGHT/brightness" >/dev/null

    # Then set external monitors to match
    set_external_monitors $(get_laptop_percentage)
  }

  function show_notify {
    local brightness="$1"
    local icon="$2"
    ${pkgs.dunst}/bin/dunstify -i display-brightness -t 1000 -r 2593 -u normal \
      "$icon $brightness%" -h int:value:"$brightness" -h string:hlcolor:$bar_color
  }

  current_brightness=$(get_laptop_percentage)

  if [[ -z "$current_brightness" ]]; then
    echo "could not get brightness"
    exit 1
  fi

  while getopts "h:a:d:" option; do
    case "$option" in
      h)
        help
        exit;;
      a)
        new_brightness=$((current_brightness + OPTARG))
        if [[ $new_brightness -gt 100 ]]; then
          new_brightness=100
        fi
        set_brightness "$new_brightness"
        show_notify "$new_brightness" "󱩕"
        exit;;
      d)
        new_brightness=$((current_brightness - OPTARG))
        if [[ $new_brightness -lt 5 ]]; then
          new_brightness=5
        fi
        set_brightness "$new_brightness"
        show_notify "$new_brightness" "󱩏"
        exit;;
      \?)
        echo invalid option
        show_notify "$current_brightness" "󰌵"
        exit;;
    esac
  done
''
