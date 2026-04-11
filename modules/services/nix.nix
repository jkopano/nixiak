# Nix user services
{ den, ... }:
{
  den.aspects.services._.nix.homeManager =
    { pkgs, ... }:
    {
      programs = {
        nix-index = {
          enable = true;
          enableZshIntegration = true;
        };
        command-not-found.enable = false; # comma handles this better
      };

      home.packages = with pkgs; [
        comma
        nurl
        nix-init
        fzy
        nix-output-monitor
        nh
      ];
    };
}
