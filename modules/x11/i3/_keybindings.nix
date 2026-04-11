{
  lib,
  mod,
  ws,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  menu = "${getExe pkgs.rofi} -show drun -show-icons";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
in
lib.mkForce {
  # === WM-Related ===
  "${mod}+q" = "kill";
  "${mod}+Shift+q" =
    "exec --no-startup-id kill -9 $(${getExe pkgs.xdotool} getwindowfocus getwindowpid)";

  "${mod}+Return" = "exec --no-startup-id $TERMINAL -e tmux";
  "${mod}+Shift+Return" = "exec --no-startup-id $TERMINAL";
  "${mod}+w" = "layout toggle tabbed split";
  "${mod}+space" = "exec --no-startup-id ${menu}";
  "${mod}+Escape" =
    "exec --no-startup-id i3-scratchpad -m 'D' -c '$TERMINAL --class=st-drop_down -e tmux new -A -s float'";
  "${mod}+grave" =
    "exec --no-startup-id i3-scratchpad -m 'D' -c '$TERMINAL --class=st-drop_down -e tmux new -A -s float'";

  # === Window Focus ===
  "${mod}+${left}" = "focus left";
  "${mod}+${down}" = "focus down";
  "${mod}+${up}" = "focus up";
  "${mod}+${right}" = "focus right";
  "${mod}+bracketright" = "workspace next";
  "${mod}+bracketleft" = "workspace prev";

  "${mod}+Tab" = "exec --no-startup-id ~/.config/i3/scripts/wmfocus-helper";

  # === Window Movement ===
  "${mod}+Shift+${left}" = "move left 50 px";
  "${mod}+Shift+${down}" = "move down 50 px";
  "${mod}+Shift+${up}" = "move up 50 px";
  "${mod}+Shift+${right}" = "move right 50 px";

  "${mod}+Ctrl+${left}" = "resize shrink width 80 px or 10 ppt";
  "${mod}+Ctrl+${right}" = "resize grow width 80 px or 10 ppt";
  "${mod}+Ctrl+${up}" = "resize shrink height 80 px or 10 ppt";
  "${mod}+Ctrl+${down}" = "resize grow height 80 px or 10 ppt";

  # Workspace switching
  "${mod}+1" = "workspace ${ws.n1}";
  "${mod}+2" = "workspace ${ws.n2}";
  "${mod}+3" = "workspace ${ws.n3}";
  "${mod}+4" = "workspace ${ws.n4}";
  "${mod}+5" = "workspace ${ws.n5}";
  "${mod}+6" = "workspace ${ws.n6}";
  "${mod}+7" = "workspace ${ws.n7}";
  "${mod}+8" = "workspace ${ws.n8}";
  "${mod}+9" = "workspace ${ws.n9}";
  "${mod}+e" = "workspace ${ws.n10}";

  # Window movement between workspaces
  "${mod}+Shift+1" = "move container to workspace ${ws.n1}; workspace ${ws.n1}";
  "${mod}+Shift+2" = "move container to workspace ${ws.n2}; workspace ${ws.n2}";
  "${mod}+Shift+3" = "move container to workspace ${ws.n3}; workspace ${ws.n3}";
  "${mod}+Shift+4" = "move container to workspace ${ws.n4}; workspace ${ws.n4}";
  "${mod}+Shift+5" = "move container to workspace ${ws.n5}; workspace ${ws.n5}";
  "${mod}+Shift+6" = "move container to workspace ${ws.n6}; workspace ${ws.n6}";
  "${mod}+Shift+7" = "move container to workspace ${ws.n7}; workspace ${ws.n7}";
  "${mod}+Shift+8" = "move container to workspace ${ws.n8}; workspace ${ws.n8}";
  "${mod}+Shift+9" = "move container to workspace ${ws.n9}; workspace ${ws.n9}";
  "${mod}+Shift+e" = "move container to workspace ${ws.n10}; workspace ${ws.n10}";

  # Session management
  "${mod}+r" = "reload";
  "${mod}+Shift+r" = "restart";

  # Bar shite
  "${mod}+i" = "bar mode toggle";

  # === LAYOUT MANAGMENT ===
  "${mod}+x" =
    "split h; exec --no-startup-id ${pkgs.dunst}/bin/dunstify 'Tile Horizontally' '|\\n|\\n|\\n|' -u URG -t 1500";
  "${mod}+z" =
    "split v; exec --no-startup-id ${pkgs.dunst}/bin/dunstify 'Tile Vertically' \"\\n___________\\n\" -u URG -t 1500";
  "${mod}+f" = "fullscreen toggle";
  "${mod}+Shift+space" = "floating toggle";
  "${mod}+a" = "focus parent";
  "${mod}+d" = "focus child";

  # Launchers
  # "${mod}+o" = "exec --no-startup-id ${getExe pkgs.dmenu_run} -h 32";

  # Keepassxc
  "${mod}+ctrl+p" = "exec --no-startup-id keepassxc-dmenu";
  "${mod}+ctrl+semicolon" = "exec --no-startup-id keepmenu";

  # Toggle floating/sticky
  "${mod}+apostrophe" = "floating toggle, sticky toggle";

  # Browser
  "${mod}+b" = "exec --no-startup-id $BROWSER";
  "${mod}+Shift+b" = "exec --no-startup-id $BROWSER --incognito";

  # File manager
  "${mod}+t" = "exec --no-startup-id ${getExe pkgs.xfce.thunar}";

  # Display management
  "${mod}+p" = "exec --no-startup-id ${getExe pkgs.autorandr} -c";

  # Screenshot
  "${mod}+shift+y" = "exec --no-startup-id ${getExe pkgs.flameshot} gui -c";
  "${mod}+y" = "exec --no-startup-id ${getExe pkgs.flameshot} gui -c -p ~/Pictures/";
  "Print" = "exec --no-startup-id ${getExe pkgs.flameshot} full -c -p ~/Pictures/";

  # Power menu
  "${mod}+BackSpace" =
    "exec --no-startup-id ${lib.getExe pkgs.rofi} -show p -modi p:'rofi-power-menu --choices=lockscreen/logout/suspend/reboot/shutdown'";

  # Media control
  "${mod}+ctrl+s" = "exec --no-startup-id media-control --toggle";
  "${mod}+ctrl+bracketright" = "exec --no-startup-id media-control --next";
  "${mod}+ctrl+bracketleft" = "exec --no-startup-id media-control --previous";
  "${mod}+shift+m" = "exec --no-startup-id media-control --mic-mute";

  # Volume control
  "${mod}+ctrl+plus" = "exec --no-startup-id media-control --vol-up";
  "${mod}+ctrl+minus" = "exec --no-startup-id media-control --vol-down";

  # Brightness control
  "${mod}+ctrl+d" = "exec --no-startup-id brightness -d 10";
  "${mod}+ctrl+i" = "exec --no-startup-id brightness -a 10";

  "F10" = "exec --no-startup-id media-control --vol-mute";
  "F11" = "exec --no-startup-id media-control --vol-down";
  "F12" = "exec --no-startup-id media-control --vol-up";
  "XF86AudioRaiseVolume" = "exec --no-startup-id media-control --vol-up";
  "XF86AudioLowerVolume" = "exec --no-startup-id media-control --vol-down";
  "XF86AudioMute" = "exec --no-startup-id media-control --vol-mute";
  "XF86AudioStop" = "exec --no-startup-id media-control --stop";
  "XF86Favorites" = "exec --no-startup-id media-control --next";
  "XF86Tools" = "exec --no-startup-id media-control --previous";
  "XF86AudioPlay" = "exec --no-startup-id media-control --toggle";
  "F6" = "exec --no-startup-id media-control --stop";
  "F9" = "exec --no-startup-id media-control --next";
  "F7" = "exec --no-startup-id media-control --previous";
  "F8" = "exec --no-startup-id media-control --toggle";
  "XF86MonBrightnessUp" = "exec --no-startup-id brightness -a 10";
  "XF86MonBrightnessDown" = "exec --no-startup-id brightness -d 10";
  "XF86Display" = "exec --no-startup-id ${lib.getExe pkgs.autorandr} -c";
}
