{
  pkgs,
  lib,
  ...
}:
let
  jq = lib.getExe pkgs.jq;
  bc = lib.getExe pkgs.bc;
  rg = lib.getExe pkgs.ripgrep;
in
pkgs.writeShellScriptBin "i3-scratchpad" ''
  set -euo pipefail

  usage() {
    echo "Usage: ''${0} <i3_mark> <launch_cmd> [options]"
    echo "Example: ''${0} 'scratch-emacs' 'emacsclient -c -a emacs'"
    echo "Options:"
    echo "  --height,  -h          Window height percentage (default: 60)"
    echo "  --width,   -w          Window width percentage  (default: 80)"
    echo "  --height-padding, -H   Top padding in pixels    (default: 25)"
    exit 1
  }

  # Validate i3 mark format
  validate_mark() {
    local mark="$1"
    echo "$mark"
    if [[ -z "$mark" ]]; then
      echo "Error: i3 mark cannot be empty"
      return 1
    fi
    if [[ ! "$mark" =~ ^[a-zA-Z0-9_-]+$ ]]; then
      echo "Error: Invalid i3 mark format. Only alphanumeric, '-', and '_' characters are allowed"
      return 1
    fi
    return 0
  }

  # Validate arguments
  if [ $# -lt 2 ]; then
    usage
  fi

  I3_MARK=""
  LAUNCH_CMD=""

  # Default values
  WIDTH=80
  HEIGHT=65
  HEIGHT_PADDING=34
  WIDTH_PADDING=0

  USE_PRIMARY=false
  MONITOR_NAME=""

  # Track mandatory flags
  HAS_CMD=false

  # Parse options
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -m | --mark)
      echo "$2"
      I3_MARK=''${2}
      shift 2
      ;;
    -c | --cmd)
      LAUNCH_CMD=''${2}
      HAS_CMD=true
      shift 2
      ;;
    -h | --height)
      if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: Height must be a number"
        usage
      fi
      HEIGHT="$2"
      shift 2
      ;;
    -w | --width)
      if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: Width must be a number"
        usage
      fi
      WIDTH="$2"
      shift 2
      ;;
    -H | --height-padding)
      if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: Padding must be a number"
        usage
      fi
      HEIGHT_PADDING="$2"
      shift 2
      ;;
    -W | --width-padding)
      if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: Padding must be a number"
        usage
      fi
      WIDTH_PADDING="$2"
      shift 2
      ;;
    -p | --primary)
      USE_PRIMARY=true
      shift
      ;;
    *)
      echo "Error: Unknown option $1"
      usage
      ;;
    esac
  done

  if ! validate_mark "$I3_MARK"; then
    usage
  fi

  # Check mandatory flags
  if ! $HAS_CMD; then
    echo "Error: Missing required options"
    echo ""
    usage
  fi

  # Validate percentage values
  if ((WIDTH < 1 || WIDTH > 100)); then
    echo "Error: Width must be between 1 and 100"
    exit 1
  fi

  if ((HEIGHT < 1 || HEIGHT > 100)); then
    echo "Error: Height must be between 1 and 100"
    exit 1
  fi

  marks=($(i3-msg -t get_marks | jq -r '.[]'))

  is_scratchpad_open=false
  for x in "''${marks[@]}"; do
    if [[ "$x" == "$I3_MARK" ]]; then
      is_scratchpad_open=true
    fi
  done

  get_primary_monitor() {
    primary=$(xrandr --listmonitors | awk '/\*/ {print $4}')
    if [[ -z "$primary" ]]; then
      echo "Warning: No primary monitor detected, falling back to focused monitor" >&2
      primary=$(i3-msg -t get_workspaces | ${jq} -r '.[] | select(.focused==true).output')
    fi
    echo "$primary"
  }

  scratchpad_show() {
    local monitor

    # Determine which monitor to use
    if $USE_PRIMARY; then
      monitor=$(get_primary_monitor)
    else
      monitor=$(i3-msg -t get_workspaces | ${jq} -r '.[] | select(.focused==true).output')
    fi

    MONITOR_SIZE=$(xrandr | ${rg} "$monitor" | ${rg} "[0-9]+x[0-9]+\+[0-9]+\+[0-9]+" -o)
    monitor_size_x=$(echo "$MONITOR_SIZE" | cut -d 'x' -f1)
    window_size_x=$(echo "$monitor_size_x" \* "$WIDTH" / 100 | ${bc})

    monitor_size_y=$(echo "$MONITOR_SIZE" | cut -d 'x' -f2 | cut -d'+' -f1)
    window_size_y=$(echo "$monitor_size_y" \* "$HEIGHT" / 100 | ${bc})

    padding_x=$(echo "$MONITOR_SIZE" | cut -d '+' -f2)
    padding_x=$(echo \("$monitor_size_x" - "$window_size_x"\) / 2 + "$padding_x" | ${bc} | xargs -I @ echo "$WIDTH_PADDING + @" | ${bc})

    padding_y=$(echo "$MONITOR_SIZE" |
      cut -d '+' -f3 | ${bc} |
      xargs -I @ echo "$HEIGHT_PADDING + @" | ${bc})

    i3-msg "[con_mark=''${I3_MARK}]" \
      scratchpad show, \
      resize set "$window_size_x" px "$window_size_y" px, \
      move position "$padding_x" px "$padding_y" px
  }

  # try showing the scratchpad window
  if [[ "$is_scratchpad_open" == false ]]; then
    # if there is no such window...

    # launch the application.
    eval "''${LAUNCH_CMD}" &

    # Wait for the next window event.
    i3-msg -t subscribe '[ "window" ]'

    # Set a mark
    i3-msg mark "''${I3_MARK}"

    # Move it to the scratchpad workspace
    i3-msg move scratchpad

    # show the scratchpad window
    scratchpad_show

  else
    scratchpad_show
  fi
''
