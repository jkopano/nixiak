{ den, inputs, ... }:
{
  den.aspects.wayland._.noctalia.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      configDir = "/home/kuba/.config/nixos";
    in
    {
      imports = [
        {
          key = "noctalia-flake-module-dedup";
          imports = [ inputs.noctalia.homeModules.default ];
        }
      ];

      home.packages = with pkgs; [
        gpu-screen-recorder
        evolution
        evolution-data-server
      ];

      stylix.targets.noctalia-shell.enable = false;
      programs.noctalia-shell = {
        enable = true;
        # systemd.enable = true;
        settings = {
          appLauncher = {
            terminalCommand = "kitty -e"; # or "gnome-terminal --", "alacritty -e", etc.
          };
          # colorSchemes = {
          #   darkMode = true;
          #   # predefinedScheme = "GruvboxAlt";
          # };
          hooks = {
            enabled = true;
            performanceModeEnabled = "noctalia-performance enable";
          };
          brightness = {
            enableDdcSupport = true;
            enforceMinimum = true;
          };
          dock.enabled = false;
          bar = {
            density = "comfortable";
            position = "right";
            backgroundOpacity = 1.0;
            capsuleOpacity = 1.0;
            showCapsule = true;
            hideOnOverview = true;
            outerCorners = true;
            monitors = [
              "DP-3"
              "eDP-1"
            ];
            widgets = {
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
                {
                  formatHorizontal = "HH:mm";
                  formatVertical = "HH mm";
                  id = "Clock";
                  useMonospacedFont = true;
                  usePrimaryColor = true;
                }
                {
                  id = "plugin:notes-scratchpad";
                }
                {
                  id = "MediaMini";
                }
              ];
              center = [
                {
                  id = "Workspace";
                  hideUnoccupied = true;
                  labelMode = "none";
                  showApplications = true;
                  followFocusedScreen = true;
                }
              ];
              right = [
                {
                  id = "Tray";
                  drawerEnabled = false;
                }
                {
                  id = "plugin:screen-recorder";
                }
                {
                  id = "plugin:tailscale";
                }
                {
                  id = "Network";
                }
                {
                  id = "Bluetooth";
                  displayMode = "alwaysShow";
                }
                {
                  id = "Brightness";
                  displayMode = "alwaysHide";
                  enableDdcSupport = true;
                  enforceMinimum = true;
                }
                {
                  id = "Volume";
                }
                {
                  alwaysShowPercentage = false;
                  id = "Battery";
                  warningThreshold = 30;
                  showPowerProfiles = true;
                  showNoctaliaPerformance = true;
                }
              ];
            };
          };

          general = {
            avatarImage = "${configDir}/res/face.png";
            radiusRatio = 0.5;
            compactLockScreen = true;
          };
          ui = {
            fontDefault = "Maple Mono";
            fontDefaultScale = 1.25;
            panelBackgroundOpacity = 1.0;
          };
          wallpaper = {
            overviewEnabled = true;
          };
          location = {
            monthBeforeDay = true;
          };

          plugins = {
            sources = [
              {
                enabled = true;
                name = "Official Noctalia Plugins";
                url = "https://github.com/noctalia-dev/noctalia-plugins";
              }
            ];
            states = {
              screen-recorder = {
                enabled = true;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
              keybind-cheatsheet = {
                enabled = true;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
              tailscale = {
                enabled = true;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
              polkit-agent = {
                enabled = false;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
              niri-overview-launcher = {
                enabled = true;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
              notes-scratchpad = {
                enabled = true;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
            };
            version = 1;
          };
        };
      };
      home.file.".cache/noctalia/wallpapers.json" = {
        text = builtins.toJSON {
          defaultWallpaper = "/home/kuba/Pictures/Wallpapers/clay-banks-u27Rrbs9Dwc-unsplash.jpg";
        };
      };
    };
}
