# Kanshi display configuration
{ den, ... }:
{
  den.aspects.wayland._.kanshi.homeManager =
    { pkgs, ... }:
    {
      # home.packages = with pkgs; [ kanshi ];

      services.kanshi = {
        enable = false;
        systemdTarget = "niri.service";

        settings = [
          # Profile 1: Docked with lid closed (DP-3 and DP-5 only)
          {
            profile.name = "docked-closed";
            profile.outputs = [
              {
                criteria = "DP-5";
                mode = "1920x1200";
                transform = "90";
                scale = 1.0;
                position = "0,0";
              }
              {
                criteria = "DP-3";
                mode = "1920x1200";
                position = "1200,${toString (((1920 - 1200) / 2) - 180)}";
              }
              {
                criteria = "eDP-1";
                mode = "1920x1080";
                position = "${toString (((1200 + 1920) / 2) - 1920 / 2)},1920";
                # This centers eDP-1 below DP-3
              }
            ];
          }

          # Profile 2: Docked with lid open (all three monitors)
          {
            profile.name = "docked-open";
            profile.outputs = [
              {
                criteria = "DP-5";
                mode = "1920x1200";
                transform = "90";
                scale = 1.0;
                position = "0,0";
              }
              {
                criteria = "DP-3";
                mode = "1920x1200";
                position = "1200,${toString (1920 - 1200)}";
              }
              {
                criteria = "eDP-1";
                mode = "1920x1080";
                position = "${toString (((1200 + 1920) / 2) - 1920 / 2)},1920";
                # This centers eDP-1 below DP-3
              }
            ];
          }

          # Profile 3: Undocked (eDP-1 only)
          {
            profile.name = "laptop-only";
            profile.outputs = [
              {
                criteria = "eDP-1";
                mode = "1920x1080";
                position = "0,0";
              }
            ];
          }
        ];
      };
    };
}
