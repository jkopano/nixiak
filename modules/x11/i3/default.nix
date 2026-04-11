{ den, ... }:
{
  den.aspects.x11._.i3.homeManager =
    { config, inputs, pkgs, lib, ... }:
    let
      hex = str: "#${str}";
      colors = lib.mapAttrs (name: hex) config.lib.stylix.colors;
    in
    {
      imports = [
        (import ./_i3status.nix {
          inherit
            config
            lib
            inputs
            pkgs
            ;
        })
      ];

      home.file.".config/i3/scripts/wmfocus-helper" = {
        executable = true;
        text = ''
          #!/bin/sh
          # Strict error handling for i3
          set -euo pipefail

          # Your wmfocus configuration
          exec ${lib.getExe pkgs.wmfocus} \
            -c "asdfghjkl" \
            -f "JetBrainsMono:100" \
            --textcolor "${colors.base05}" \
            --bgcolorcurrent "${colors.base00}" \
            --bgcolor "rgba(69,71,90,0.75)" \
            --textcolorcurrent "${colors.yellow}"
        '';
      };

      home.packages = with pkgs; [
        killall
        i3-auto-layout
        xclip
        xidlehook
        feh
        clipmenu
        clipnotify
        picom
        rofi
        dmenu
        arandr
        xfce.thunar
        xfce.thunar-volman
        xfce.thunar-media-tags-plugin
        xfce.thunar-archive-plugin
        rofi-power-menu
        wmfocus
      ];
      services = {
        screen-locker = {
          enable = true;
          xautolock = {
            enable = true;
            detectSleep = true;
          };
        };
        betterlockscreen = {
          enable = true;
          inactiveInterval = 60;
        };
        flameshot = {
          enable = true;
          settings = {
            General = {
              disabledTrayIcon = true;
              showStartupLaunchMessage = false;
            };
          };
        };
      };
      xsession.enable = true;
      xsession.windowManager.i3 = {
        enable = true;

        config =
          let
            mod = "Mod4"; # Super/Windows key
            ws = {
              n1 = "1:   ";
              n2 = "2:   ";
              n3 = "3:   ";
              n4 = "4:   ";
              n5 = "5: 󰋀  ";
              n6 = "6";
              n7 = "7";
              n8 = "8";
              n9 = "9";
              n10 = "10:   ";
            };
          in
          {
            colors = import ./_colors.nix { inherit colors lib; };
            modifier = mod;
            focus = {
              followMouse = false;
              newWindow = "smart";
              wrapping = "no";
            };
            workspaceLayout = "default";
            floating.modifier = mod;
            gaps = {
              inner = 10;
              outer = 0;
            };
            modes = lib.mkForce { };
            window = import ./_windows.nix { inherit config ws; };
            keybindings = import ./_keybindings.nix {
              inherit
                lib
                config
                pkgs
                mod
                ws
                ;
            };

            inherit (import ./_startup.nix { inherit pkgs lib config; }) startup;
            bars = [
              {
                id = "bar-1";
                fonts = lib.mkDefault {
                  names = [ "Maple Mono" ];
                  style = "Bold";
                  size = 15.0;
                };
                position = "top";
                statusCommand = "i3status-rs ~/.config/i3status-rust/config-main.toml";
                workspaceNumbers = false;
                trayPadding = 8;
                trayOutput = "primary";
                colors = {
                  background = colors.base00;
                  statusline = colors.base05;
                  focusedStatusline = colors.base05;
                  focusedSeparator = colors.base00;
                  separator = colors.base00;

                  activeWorkspace = {
                    background = colors.base02;
                    border = colors.base00;
                    text = colors.base01;
                  };
                  inactiveWorkspace = {
                    background = colors.base00;
                    border = colors.base01;
                    text = colors.base02;
                  };
                  focusedWorkspace = {
                    background = colors.base02;
                    border = colors.base02;
                    text = colors.base05;
                  };
                };
                extraConfig = ''
                  output primary
                  binding_mode_indicator yes
                  strip_workspace_numbers yes
                '';
              }
              {
                id = "bar-2";
                fonts = lib.mkDefault {
                  names = [ "Maple Mono" ];
                  style = "Bold";
                  size = 15.0;
                };
                position = "top";
                statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-secondary.toml";
                workspaceNumbers = false;
                trayOutput = "none";
                colors = {
                  background = colors.base00;
                  statusline = colors.base05;
                  focusedStatusline = colors.base05;
                  focusedSeparator = colors.base00;
                  separator = colors.base00;

                  activeWorkspace = {
                    background = colors.base02;
                    border = colors.base00;
                    text = colors.base01;
                  };
                  inactiveWorkspace = {
                    background = colors.base00;
                    border = colors.base00;
                    text = colors.base01;
                  };
                  focusedWorkspace = {
                    background = colors.base02;
                    border = colors.base00;
                    text = colors.base05;
                  };
                };
                extraConfig = ''
                  output nonprimary
                  strip_workspace_numbers yes
                '';
              }
            ];
          };
        extraConfig = ''
          title_align center
          default_orientation horizontal
        '';
      };
    };
}