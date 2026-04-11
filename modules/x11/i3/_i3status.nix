{
  pkgs,
  config,
  lib,
  ...
}:
let
  # colors = config.lib.stylix.colors;
  hex = str: "#${str}";
  colors = lib.mapAttrs (name: hex) config.lib.stylix.colors;
in
{
  programs.i3status-rust = {
    enable = true;

    bars = {
      main = {
        icons = "material-nf";
        # theme = "default";
        settings = {
          theme = {
            overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base05;
              good_bg = colors.base00;
              good_fg = colors.base05;
              info_bg = colors.base00;
              info_fg = colors.base07;
              warning_bg = colors.base00;
              warning_fg = colors.base0A;
              critical_bg = colors.base00;
              critical_fg = colors.base08;
              separator_bg = colors.base00;
              separator_fg = colors.base02;
              separator = " | ";
            };
          };
        };

        blocks = [
          {
            block = "focused_window";
            format = {
              full = "$title.str(max_w:60)|";
              short = " ";
            };
          }
          {
            block = "time";
            interval = 5;
            format = " $timestamp.datetime(f:'%R')";
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base0D;
            };
            click = [
              {
                button = "left";
                action = "cmd";
                cmd = "eww-widgets -c";
              }
            ];
          }
          {
            block = "sound";
            format = "$icon ";
            merge_with_next = true;
            max_vol = 100;
            click = [
              {
                button = "left";
                action = "toggle_mute";
              }
              {
                button = "wheel_down";
                action = "cmd";
                cmd = "media-control --vol-down";
              }
              {
                button = "wheel_up";
                action = "cmd";
                cmd = "media-control --vol-up";
              }
            ];
            theme_overrides = {
              idle_fg = colors.base0E;
              warning_fg = colors.base02;
            };
          }
          {
            block = "sound";
            driver = "pulseaudio";
            format = "$icon ";
            device_kind = "source";
            merge_with_next = true;
            click = [
              {
                button = "left";
                action = "toggle_mute";
              }
              {
                button = "wheel_down";
                action = "cmd";
                cmd = "MediaControl --mic-down";
              }
              {
                button = "wheel_up";
                action = "cmd";
                cmd = "MediaControl --mic-up";
              }
            ];
            theme_overrides = {
              idle_fg = colors.base0E;
              warning_fg = colors.base02;
            };
          }
          {
            block = "bluetooth";
            mac = "99:D9:E3:B1:E1:A4";
            disconnected_format = "󰂲 ";
            format = "$icon ";
            merge_with_next = true;
            battery_state = {
              "0..30" = "critical";
              "31..80" = "warning";
              "81..100" = "good";
            };
            click = [
              {
                button = "left";
                cmd = "bluetooth-widget";
              }
            ];
          }
          {
            block = "music";
            format = "{$icon }";
            player = "YoutubeMusic";
            signal = 40;
            merge_with_next = true;
            click = [
              {
                button = "left";
                cmd = "eww-widgets -m";
                sync = true;
              }
              {
                button = "right";
                action = "next";
              }
              {
                button = "middle";
                action = "prev";
              }
            ];
          }
          {
            block = "backlight";
            cycle = [
              45
              100
            ];
            format = "$icon ";
            missing_format = "";
            merge_with_next = true;
            root_scaling = 2.5;
          }
          {
            block = "battery";
            format = "$icon{ $time_remaining.dur(hms:false, pad_with:'', min_unit:m, units:1, unit_space:false)}";
            full_format = "$icon";
            device = "DisplayDevice";
            driver = "upower";
            missing_format = "| ";
            click = [
              {
                button = "left";
                cmd = "battery";
              }
            ];
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base0B;
              good_bg = colors.base00;
              good_fg = colors.base05;
              warning_bg = colors.base00;
              warning_fg = colors.base09;
              critical_bg = colors.base00;
              critical_fg = colors.base08;
            };
          }
          {
            block = "custom";
            interval = "once";
            format = "(";
            command = "";
            merge_with_next = true;
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base02;
            };
          }
          {
            block = "memory";
            format = "$icon $mem_used_percents.bar(w:3, v:true)";
            interval = 1;
            warning_mem = 15;
            critical_mem = 92;
            merge_with_next = true;
            click = [
              {
                button = "left";
                cmd = "cpu_widgets -b";
              }
            ];
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base05;
              good_bg = colors.base00;
              good_fg = colors.base07;
              warning_bg = colors.base00;
              warning_fg = colors.base09;
              critical_bg = colors.base00;
              critical_fg = colors.base08;
            };
          }
          {
            block = "custom";
            interval = "once";
            format = " ";
            command = "";
            merge_with_next = true;
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base07;
            };
          }
          {
            block = "cpu";
            format = "$icon ";
            interval = 1;
            info_cpu = 40;
            warning_cpu = 70;
            critical_cpu = 90;
            merge_with_next = true;
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base07;
              good_bg = colors.base00;
              good_fg = colors.base0B;
              info_bg = colors.base00;
              info_fg = colors.base0E;
              warning_bg = colors.base00;
              warning_fg = colors.base09;
              critical_bg = colors.base00;
              critical_fg = colors.base08;
            };
            click = [
              {
                button = "left";
                cmd = "cpu_widgets -b";
              }
            ];
          }
          {
            block = "custom";
            interval = "once";
            format = ")";
            command = " ";
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base02;
            };
          }
          {
            block = "custom";
            format = "$text  ";
            merge_with_next = true;
            command = "mountpoint -q ${config.var.sftp} && echo '󰌘' || echo '󰌙 '";
            interval = 5;
            click = [
              {
                button = "left";
                action = "cmd";
                cmd = "systemctl --user restart rclone-mount:.srv.sftpuser.data.@sftp.service";
              }
              {
                button = "right";
                action = "cmd";
                cmd = "umount ${config.var.sftp}";
              }
            ];
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base05;
            };
          }
          # {
          #   block = "net";
          #   format = "$icon {$signal_strength $ssid$frequency | }";
          #   format_alt = "^icon_net_down$speed_down.eng(prefix:K) ^icon_net_up$speed_up.eng(prefix:K) ";
          #   merge_with_next = true;
          #   theme_overrides = {
          #     idle_bg = colors.base00;
          #     idle_fg = colors.base05;
          #   };
          # }
          {
            block = "scratchpad";
            format = "$icon$count.eng(range:1..) |$icon 0 ";
            merge_with_next = true;
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base05;
            };
          }
          {
            block = "notify";
            driver = "dunst";
            format = "$icon {($notification_count.eng(w:1))|}";
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base05;
              info_bg = colors.base00;
              info_fg = colors.base07;
            };
            click = [
              {
                button = "left";
                action = "show";
              }
              {
                button = "right";
                action = "toggle_paused";
              }
            ];
          }
          {
            block = "custom";
            interval = "once";
            format = "";
            command = " ";
            theme_overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base02;
            };
          }
        ];
      };
      secondary = {
        icons = "material-nf";

        settings = {
          theme = {
            overrides = {
              idle_bg = colors.base00;
              idle_fg = colors.base05;
              good_bg = colors.base00;
              good_fg = colors.base05;
              info_bg = colors.base00;
              info_fg = colors.base07;
              warning_bg = colors.base00;
              warning_fg = colors.base0A;
              critical_bg = colors.base00;
              critical_fg = colors.base08;
              separator_bg = colors.base00;
              separator_fg = colors.base02;
              separator = " | ";
            };
          };
        };

        blocks = [
          {
            block = "disk_space";
            info_type = "available";
            alert_unit = "GB";
            alert = 10.0;
            warning = 15.0;
            format = " $icon $available ";
            format_alt = "<i> $icon $available / $total </i>";
            theme_overrides = {
              idle_fg = colors.base0D;
            };
          }
          {
            block = "amd_gpu";
            format = " $icon $utilization ";
            format_alt = " $icon MEM: $vram_used_percents ($vram_used/$vram_total) ";
            interval = 2;
            theme_overrides = {
              idle_fg = colors.base0E;
            };
          }
          {
            block = "temperature";
            format = " $icon $max ";
            format_alt = " $icon$min min, $max max, $average avg ";
            interval = 5;
            chip = "*-isa-*";
            theme_overrides = {
              idle_fg = colors.base09;
            };
          }
          {
            block = "net";
            format = " 󰩠 $ip ";
            device = "^tailscale";
            theme_overrides = {
              idle_fg = colors.base0B;
            };
          }
        ];
      };
    };
  };

  # Ensure all required packages are available
  home.packages = with pkgs; [
    eww # For eww-widgets
    # Add any other required packages
  ];
}
