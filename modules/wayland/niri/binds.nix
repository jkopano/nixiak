{ den, ... }:
{
  den.aspects.wayland._.niri._.binds.homeManager =
    { lib, config, pkgs, ... }:
    let
      noctalia =
        cmd:
        [
          "noctalia-shell"
          "ipc"
          "call"
        ]
        ++ (pkgs.lib.splitString " " cmd);
    in
    {
      programs.niri.settings.binds =
        with config.lib.niri.actions;
        let
          set-volume = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@";
          playerctl = spawn "${pkgs.playerctl}/bin/playerctl";
          browser = spawn "${lib.getExe pkgs.firefox}";
          terminal = spawn "${lib.getExe pkgs.kitty}";
          tmux = spawn "${lib.getExe pkgs.kitty}" "-e" "tmux";
        in
        {
          "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
          "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";

          "XF86AudioPlay".action = playerctl "play-pause";
          "XF86AudioStop".action = playerctl "pause";
          "XF86AudioPrev".action = playerctl "previous";
          "XF86AudioNext".action = playerctl "next";

          "Mod+Ctrl+S".action = playerctl "play-pause";
          "Mod+Ctrl+BracketLeft".action = playerctl "previous";
          "Mod+Ctrl+BracketRight".action = playerctl "next";
          "Mod+Ctrl+Minus".action = set-volume "5%-";
          "Mod+Ctrl+Equal".action = set-volume "5%+";

          "XF86AudioRaiseVolume".action = set-volume "5%+";
          "XF86AudioLowerVolume".action = set-volume "5%-";

          # "F12".action = set-volume "5%+";
          # "F11".action = set-volume "5%-";

          "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
          "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";

          "Print".action.screenshot-screen = {
            write-to-disk = true;
          };
          "Mod+Y".action.screenshot = {
            show-pointer = false;
          };
          "Mod+B".action = browser;
          "Mod+Semicolon".action = spawn "${pkgs.anyrun}/bin/anyrun";
          "Mod+Return".action = tmux;
          "Mod+Shift+Return".action = terminal;

          "Mod+Q".action = close-window;
          "Mod+E".action = center-column;
          "Mod+Tab".action = maximize-column;
          "Mod+BracketRight".action = switch-preset-column-width;
          "Mod+BracketLeft".action = switch-preset-column-width-back;
          "Mod+Ctrl+Space".action = spawn "vicinae" "toggle";
          "Mod+Space".action = spawn "vicinae" "toggle";
          "Mod+BackSpace".action.spawn = noctalia "lockScreen lock";
          "Mod+Shift+BackSpace".action.spawn = noctalia "sessionMenu toggle";
          "Mod+Ctrl+BackSpace".action.spawn = noctalia "sessionMenu toggle";
          "Mod+Escape".action = toggle-overview;
          "Mod+Slash".action.spawn = noctalia "plugin:keybind-cheatsheet toggle";

          "Mod+1".action.focus-workspace = "1";
          "Mod+2".action.focus-workspace = "2";
          "Mod+3".action.focus-workspace = "3";
          "Mod+4".action.focus-workspace = "4";

          "Mod+Shift+1".action.move-column-to-workspace = "1";
          "Mod+Shift+2".action.move-column-to-workspace = "2";
          "Mod+Shift+3".action.move-column-to-workspace = "3";
          "Mod+Shift+4".action.move-column-to-workspace = "4";
          "Mod+F".action = fullscreen-window;
          "Mod+Shift+Space".action = toggle-window-floating;
          "Mod+W".action = toggle-column-tabbed-display;

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;
          "Mod+C".action = center-visible-columns;

          "Mod+Ctrl+H".action = set-column-width "-10%";
          "Mod+Ctrl+L".action = set-column-width "+10%";
          "Mod+Ctrl+J".action = set-window-height "+10%";
          "Mod+Ctrl+K".action = set-window-height "-10%";

          "Mod+H".action = focus-column-or-monitor-left;
          "Mod+L".action = focus-column-or-monitor-right;
          "Mod+J".action = focus-window-or-workspace-down;
          "Mod+K".action = focus-window-or-workspace-up;

          "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
          "Mod+Shift+L".action = move-column-right-or-to-monitor-right;
          "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
          "Mod+Shift+J".action = move-window-down-or-to-workspace-down;

          "Mod+WheelScrollDown".action = focus-window-or-workspace-down;
          "Mod+WheelScrollUp".action = focus-window-or-workspace-up;
          "Mod+Shift+WheelScrollDown".action = focus-column-or-monitor-right;
          "Mod+Shift+WheelScrollUp".action = focus-column-or-monitor-left;
        };
    };
}
