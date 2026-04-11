{ den, ... }:
{
  den.aspects.wayland._.shikane.homeManager =
    { pkgs, ... }:
    {
      services.shikane = {
        enable = true;
        settings = {
          profile = [
            {
              name = "docked-closed";
              output = [
                {
                  search = "n=DP-5";
                  enable = true;
                  mode = "1920x1200";
                  position = "0,0";
                  transform = "90";
                  scale = 1.0;
                }
                {
                  search = "n=DP-3";
                  enable = true;
                  mode = "1920x1200";
                  position = "1200,${toString (((1920 - 1200) / 2) + 100)}";
                  scale = 1.0;
                }
                {
                  search = "n=eDP-1";
                  enable = false;
                }
              ];
            }
            {
              name = "laptop-only";
              output = [
                {
                  search = "n=eDP-1";
                  enable = true;
                  mode = "1920x1080";
                  position = "0,0";
                  scale = 1.0;
                }
              ];
            }
          ];
        };
      };
    };
}
