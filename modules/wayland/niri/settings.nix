{ den, ... }:
{
  den.aspects.wayland._.niri._.settings.homeManager =
    { config, pkgs, ... }:
    let
      makeCommand = command: {
        command = [ command ];
      };
    in
    {
      programs.niri.settings = {
        environment = {
          CLUTTER_BACKEND = "wayland";
          # DISPLAY = null;
          GDK_BACKEND = "wayland,x11";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
        };
        spawn-at-startup = [
          # (makeCommand "hyprlock")
          (makeCommand "noctalia-shell")
          (makeCommand "systemctl --user restart xremap.service")
          (makeCommand "vicinae server")
          {
            command = [
              "wl-paste"
              "--watch"
              "cliphist"
              "store"
            ];
          }
          {
            command = [
              "wl-paste"
              "--type text"
              "--watch"
              "cliphist"
              "store"
            ];
          }
          (makeCommand "pear-desktop")
          (makeCommand "keepassxc")
        ];
        input = {
          keyboard = {
            repeat-delay = 180;
            repeat-rate = 50;
          };

          touchpad = {
            click-method = "button-areas";
            dwt = true;
            dwtp = true;
            natural-scroll = true;
            scroll-method = "two-finger";
            tap = true;
            tap-button-map = "left-right-middle";
            middle-emulation = true;
            accel-profile = "adaptive";
          };
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "70%";
          };
          warp-mouse-to-focus.enable = false;
          workspace-auto-back-and-forth = false;
        };
        screenshot-path = "~/Pictures/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";
        gestures = {
          hot-corners.enable = false;
        };

        debug = {
          honor-xdg-activation-with-invalid-serial = [ ];
        };

        workspaces = {
          "4".open-on-output = "DP-3";
          "3".open-on-output = "DP-3";
          "2".open-on-output = "DP-3";
          "1".open-on-output = "DP-5";
        };

      };
    };
}
