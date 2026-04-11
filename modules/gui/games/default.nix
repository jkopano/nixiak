{ den, ... }:
{
  den.aspects.gui._.games = {
    nixos =
      { ... }:
      {
        programs.steam = {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
        };
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          xonotic
        ];
      };
  };
}
