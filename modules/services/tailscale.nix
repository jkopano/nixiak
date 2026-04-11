{ den, ... }:
{
  den.aspects.services._.tailscale = {
    nixos =
      { ... }:
      {
        services = {
          tailscale = {
            enable = true;
            openFirewall = true;
          };
        };

        networking.firewall = {
          trustedInterfaces = [ "tailscale0" ];
          checkReversePath = "loose";
        };
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          tailscale
        ];
      };
  };
}
