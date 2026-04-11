{
  pkgs,
  config,
  ...
}:
pkgs.writeShellScriptBin "fzf-session" ''
  #!${pkgs.bash}/bin/bash

  set -o errexit -o nounset -o pipefail

  VERSION="1.1.0"
  TMUX_SESSION_FILE="''${TMUX_SESSION_FILE:-${config.xdg.configHome}/tmux/tmux_sessions}"
  ZELLIJ_SESSION_FILE="''${ZELLIJ_SESSION_FILE:-${config.xdg.configHome}/tmux/tmux_sessions}"
  MODE="tmux" # Default mode

  show_help() {
    cat <<EOF
  session-manager v''${VERSION} - Manage tmux/zellij sessions

  Usage: $0 [COMMAND] [OPTIONS]

  Commands:
    add [PATH]    Add current directory to session file
    open          Open session from file
    del           Remove session from file
    close         Close selected session(s)
    focus         Switch to another session
    choose        Select window/tab to focus (tmux only)
    list          List all available sessions
    version       Show version information

  Options:
    --file PATH   Use custom session file path
    -z, --zellij  Use zellij mode (default: tmux)
    -t, --tmux    Use tmux mode (default)
    -h, --help    Show this help message

  Examples:
    $0 add ~/projects       # Add directory to tmux sessions
    $0 -z open              # Open zellij session from list
    $0 close                # Close selected tmux session
  EOF
    exit 0
  }

  get_session_file() {
    if [[ "$MODE" == "zellij" ]]; then
      echo "$ZELLIJ_SESSION_FILE"
    else
      echo "$TMUX_SESSION_FILE"
    fi
  }

  notify() {
    local urgency="''${2:-low}"
    notify-send --urgency="''$urgency" "session-manager" "$1"
  }

  fzf_select() {
    ${pkgs.fzf}/bin/fzf --tmux 80%,80% --reverse --border --prompt="$1" "''${@:2}" --print-query --reverse | tail -1 || true
  }

  ensure_running() {
    if [[ "$MODE" == "tmux" ]]; then
      if [[ -z "''${TMUX-}" ]]; then
        echo "Error: This script must be run inside tmux" >&2
        exit 1
      fi
    else
      if [[ -z "''${ZELLIJ-}" ]]; then
        echo "Error: This script must be run inside zellij" >&2
        exit 1
      fi
    fi
  }

  ensure_session_file() {
    local session_file
    session_file=$(get_session_file)
    if [[ ! -f "$session_file" ]]; then
      mkdir -p "$(dirname "$session_file")"
      touch "$session_file"
    fi
  }

  add_session() {
    local path="''${1:-$PWD}"
    local name
    local session_file
    session_file=$(get_session_file)

    name=$(
      printf "" |
        fzf_select +i --prompt "$(pwd) "
    )

    if [[ -n "$name" ]]; then
      echo "''${name} ''${path}" >>"$session_file"
    fi
  }

  open_session() {
    ensure_session_file
    local session_file
    session_file=$(get_session_file)
    local selection
    selection=$(awk '{print $1}' "$session_file" | sort | fzf_select "Open session: ")

    if [[ -n "$selection" ]]; then
      local path
      path=$(awk -v sel="$selection" '$1 == sel {print $2}' "$session_file")

      if [[ -n "$path" ]]; then
        if [[ "$MODE" == "zellij" ]]; then
          zellij action new-tab
          zellij action write-chars "cd $path"
          zellij action write 13
        else
          tmux new-window -c "$path" -n "$selection"
        fi
      else
        echo "Error: Could not find path for session '$selection'" >&2
        exit 1
      fi
    fi
  }

  delete_session() {
    ensure_session_file
    local session_file
    session_file=$(get_session_file)
    local selection
    selection=$(awk '{print $1}' "$session_file" | sort | fzf_select "Delete session: ")

    if [[ -n "$selection" ]]; then
      local confirm
      confirm=$(printf "no\nyes" | fzf_select "Confirm delete '$${selection}'? ")

      if [[ "$confirm" == "yes" ]]; then
        sed -i "/^''${selection} /d" "$session_file"
      fi
    fi
  }

  close_sessions() {
    ensure_running
    if [[ "$MODE" == "zellij" ]]; then
      local sessions
      sessions=$(zellij list-sessions)
      local selected=()
      while IFS= read -r line; do
        selected+=("$line")
      done < <(printf "%s\n" "$sessions" | fzf_select "Close session(s): " --multi)

      for session in "''${selected[@]}"; do
        zellij kill-session "$session"
      done
    else
      local current_session
      current_session=$(tmux display-message -p '#S')
      local sessions
      sessions=$(tmux list-sessions -F '#S' | grep -v "^$${current_session}$")
      local selected=()
      while IFS= read -r line; do
        selected+=("$line")
      done < <(printf "%s\n" "$sessions" | fzf_select "Close session(s): " --multi)

      for session in "''${selected[@]}"; do
        tmux kill-session -t "$session"
      done

      if printf "%s\n" "''${selected[@]}" | grep -q "^''${current_session}$"; then
        tmux kill-session
      fi
    fi
  }

  focus_session() {
    ensure_running
    if [[ "$MODE" == "zellij" ]]; then
      local sessions
      sessions=$(zellij list-sessions)
      local selection
      selection=$(printf "%s\n" "$sessions" | fzf_select "Switch to session: ")

      if [[ -n "$selection" ]]; then
        zellij attach "$selection"
      fi
    else
      local current_session
      current_session=$(tmux display-message -p '#S')
      local sessions
      sessions=$(tmux list-sessions -F '#S' | grep -v "^''${current_session}$")
      local selection
      selection=$(printf "%s\n" "$sessions" | fzf_select "Switch to session: ")

      if [[ -n "$selection" ]]; then
        tmux switch-client -t "$selection"
      fi
    fi
  }

  choose_window() {
    if [[ "$MODE" == "zellij" ]]; then
      echo "Error: Window selection is not supported in zellij mode" >&2
      exit 1
    fi

    ensure_running
    local windows
    windows=$(tmux list-windows -F '#I: #W')
    local selection
    selection=$(printf "%s\n" "$windows" | fzf_select "Select window: ")

    if [[ -n "$selection" ]]; then
      local window_index
      window_index=$(echo "$selection" | cut -d':' -f1)
      tmux select-window -t "$window_index"
    fi
  }

  list_sessions() {
    ensure_session_file
    local session_file
    session_file=$(get_session_file)
    if [[ -s "$session_file" ]]; then
      echo "Saved sessions (mode: $MODE):"
      column -t "$session_file"
    else
      echo "No sessions saved in ''${session_file}"
    fi
  }

  rename_session() {
    ensure_running
    ensure_session_file
    local session_file
    session_file=$(get_session_file)

    if [[ "$MODE" == "zellij" ]]; then
      local sessions
      sessions=$(zellij list-sessions)
      local old_name
      old_name=$(printf "%s\n" "$sessions" | fzf_select "Rename session: ")

      if [[ -n "$old_name" ]]; then
        local new_name
        read -rp "New name for session '$old_name': " new_name

        if [[ -n "$new_name" ]]; then
          zellij rename-session "$old_name" "$new_name"

          # Update session file if entry exists
          if grep -q "^$old_name " "$session_file"; then
            sed -i "s/^$old_name /$new_name /" "$session_file"
          fi
        fi
      fi
    else
      local current_session
      current_session=$(tmux display-message -p '#S')
      local sessions
      sessions=$(tmux list-sessions -F '#S')
      local old_name
      old_name=$(printf "%s\n" "$sessions" | fzf_select "Rename session: ")

      if [[ -n "$old_name" ]]; then
        local new_name
        read -rp "New name for session '$old_name': " new_name

        if [[ -n "$new_name" ]]; then
          tmux rename-session -t "$old_name" "$new_name"

          # Update session file if entry exists
          if grep -q "^$old_name " "$session_file"; then
            sed -i "s/^$old_name /$new_name /" "$session_file"
          fi
        fi
      fi
    fi
  }

  main() {
    while [[ $# -gt 0 ]]; do
      case "$1" in
      --file)
        if [[ "$MODE" == "zellij" ]]; then
          ZELLIJ_SESSION_FILE="$2"
        else
          TMUX_SESSION_FILE="$2"
        fi
        shift 2
        ;;
      -z|--zellij)
        MODE="zellij"
        shift
        ;;
      -t|--tmux)
        MODE="tmux"
        shift
        ;;
      -h|--help)
        show_help
        ;;
      -v|--version)
        echo "session-manager v''${VERSION} (mode: $MODE)"
        exit 0
        ;;
      add)
        shift
        add_session "$@"
        exit 0
        ;;
      open)
        open_session
        exit 0
        ;;
      del)
        delete_session
        exit 0
        ;;
      close)
        close_sessions
        exit 0
        ;;
      focus)
        focus_session
        exit 0
        ;;
      choose)
        choose_window
        exit 0
        ;;
      list)
        list_sessions
        exit 0
        ;;
      rename)
        rename_session
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        show_help
        ;;
      esac
    done

    show_help
  }

  main "$@"
''
