{ pkgs, ... }:
pkgs.writeShellScriptBin "nvim-godot"
  # bash
  ''
    server_path="$HOME/.cache/godot-server.pipe"
    tmux_session="godot"
    server_startup_delay=0.2

    server_alive() {
        "$EDITOR" --server "$server_path" --remote-expr 1 >/dev/null 2>&1
    }

    tmux_has_client() {
        [ -n "$(tmux list-clients -t "$tmux_session" 2>/dev/null)" ]
    }

    ensure_tmux_and_server() {
        if ! tmux has-session -t "$tmux_session" 2>/dev/null; then
            "$TERMINAL" -e tmux new-session -s "$tmux_session" \
              "$EDITOR --listen $server_path"
            return
        fi

        if ! tmux_has_client; then
            "$TERMINAL" -e tmux attach -t "$tmux_session"
        fi
        sleep $server_startup_delay

        # Ensure nvim server is running
        # if ! server_alive; then
        #     tmux send-keys -t "$tmux_session" "$EDITOR --listen $server_path" C-m
        #     sleep $server_startup_delay
        # fi
    }

    open_file() {
        file="$1"
        line="$2"

        "$EDITOR" --server "$server_path" \
          --remote-expr "execute('edit ' . fnameescape('$file')) | cursor($line, 1)"
    }

    ensure_tmux_and_server
    open_file "$1" "$2"
  ''
