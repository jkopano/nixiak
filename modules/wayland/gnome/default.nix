{ den, __findFile, ... }:
{
  den.aspects.wayland._.gnome = {
    includes = [ <wayland/vicinae> ];
    homeManager =
      { pkgs, ... }:
      {
        home = {
          packages = with pkgs; [
            gnome-tweaks
            gnome-extension-manager
            adwsteamgtk
          ];
        };

        programs = {
          gnome-shell = {
            enable = true;

            theme = {
              package = pkgs.marble-shell-theme;
              name = "Marble-gray-dark";
            };

            extensions = with pkgs.gnomeExtensions; [
              { package = appindicator; }
              { package = paperwm; }
              { package = xremap; }
              { package = lockscreen-extension; }
              { package = extension-list; }
              { package = clipqr; }
              { package = clipboard-indicator; }
              { package = in-picture; }
              { package = tailscale-status; }
              { package = muteunmute; }

              { package = bluetooth-battery-meter; }
              { package = vicinae; }

              { package = dash-to-dock; }
              { package = app-grid-tuner; }
              { package = kiwi-is-not-apple; }
            ];
          };
        };
      };
  };
}
