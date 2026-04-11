{
  config,
  ws,
  ...
}: {
  border = 3;
  hideEdgeBorders = "smart";
  titlebar = false;
  commands = [
    {
      command = ''title format "<b>%title</b>"'';
      criteria = {class = ".*";};
    }
    {
      command = ''title_window_icon on'';
      criteria = {
        class = ".*";
      };
    }
    # Plasma desktop cleanup
    {
      command = "kill, floating enable, border none";
      criteria = {title = "Desktop — Plasma";};
    }

    # Pop-up windows
    {
      command = "floating enable";
      criteria = {window_role = "pop-up";};
    }
    {
      command = "no_focus";
      criteria = {window_role = "pop-up";};
    }

    # Workspace-specific rules
    {
      command = "layout tabbed";
      criteria = {workspace = ws.n10;};
    }
    {
      command = "move container output primary";
      criteria = {class = "bluetooth_widget";};
    }

    # Application workspace assignments
    {
      command = "move workspace ${ws.n10}";
      criteria = {class = "com.github.th_ch.youtube_music";};
    }
    {
      command = "move workspace ${ws.n10}";
      criteria = {class = "discord";};
    }
    {
      command = "move workspace ${ws.n10}";
      criteria = {class = "vesktop";};
    }
    {
      command = "move workspace ${ws.n1}";
      criteria = {class = "qutebrowser";};
    }
    {
      command = "move workspace ${ws.n1}";
      criteria = {class = "Vivaldi";};
    }
    {
      command = "move workspace ${ws.n1}";
      criteria = {class = "firefox";};
    }
    {
      command = "move workspace ${ws.n1}";
      criteria = {class = "Brave-browser";};
    }
    {
      command = "move workspace ${ws.n3}";
      criteria = {class = "Teams";};
    }
    {
      command = "move workspace ${ws.n10}";
      criteria = {class = "${config.var.pwa.twitter}";};
    }
    {
      command = "move workspace ${ws.n10}";
      criteria = {class = "${config.var.pwa.reddit}";};
    }
    {
      command = "move workspace ${ws.n10}";
      criteria = {class = "${config.var.pwa.messenger}";};
    }
    {
      command = "floating enable";
      criteria = {class = "gnome-calculator";};
    }
    {
      command = "move workspace ${ws.n3}";
      criteria = {class = "Deluge";};
    }
    {
      command = "move workspace ${ws.n3}";
      criteria = {class = "leagueclientux.exe";};
    }
    {
      command = "floating enable";
      criteria = {class = "PacketTracer";};
    }
    {
      command = "move workspace ${ws.n3}";
      criteria = {class = "riotclientux.exe";};
    }
    {
      command = "move workspace ${ws.n3}, tiling enable";
      criteria = {class = "dwarf fortress.exe";};
    }
    {
      command = "move workspace ${ws.n3}, fullscreen";
      criteria = {class = "league of legends.exe";};
    }

    # Title-based rules
    {
      command = "floating enable, move position center";
      criteria = {title = "(?i)Friends List";};
    }
    {
      command = "floating enable, move position center";
      criteria = {title = "(?i)Steam - News";};
    }
    {
      command = "move workspace ${ws.n10}, floating toggle";
      criteria = {title = "Youtube Music";};
    }
    {
      command = "floating enable";
      criteria = {title = "i3switcherX11";};
    }

    # Plasma compatibility
    {
      command = "floating enable";
      criteria = {window_role = "task_dialog";};
    }

    # Floating windows
    {
      command = "floating enable";
      criteria = {class = "eww";};
    }
    {
      command = "floating enable";
      criteria = {class = "yakuake";};
    }
    {
      command = "floating enable";
      criteria = {class = "systemsettings";};
    }
    {
      command = "floating enable";
      criteria = {class = "plasmashell";};
    }
    {
      command = "floating enable, border none";
      criteria = {class = "Plasma";};
    }
    {
      command = "floating enable, border none";
      criteria = {title = "plasma-desktop";};
    }
    {
      command = "floating enable, border none";
      criteria = {title = "win7";};
    }
    {
      command = "floating enable, border none";
      criteria = {class = "krunner";};
    }
    {
      command = "floating enable, border none";
      criteria = {class = "Kmix";};
    }
    {
      command = "floating enable, border none";
      criteria = {class = "Klipper";};
    }
    {
      command = "floating enable, border none";
      criteria = {class = "Plasmoidviewer";};
    }
    {
      command = "floating disable";
      criteria = {class = "(?i)*nextcloud*";};
    }

    # Notification handling
    {
      command = "border none, move position 70 ppt 81 ppt";
      criteria = {
        class = "plasmashell";
        window_type = "notification";
      };
    }
    {
      command = "no_focus";
      criteria = {
        class = "plasmashell";
        window_type = "notification";
      };
    }
  ];
}
