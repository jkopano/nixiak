{ den, ... }:
{
  den.aspects.tui._.nh.homeManager =
    { config, pkgs, ... }:
    let
      configDir = "/home/kuba/.config/nixos";
    in
    {
      home.packages = with pkgs; [ nix-du ];

      programs.nh = {
        enable = true;
        flake = configDir;
        clean = {
          enable = false;
        };
      };
    };
}
