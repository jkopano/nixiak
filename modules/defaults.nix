{
  den,
  inputs,
  __findFile,
  ...
}:
{
  den.default = {
    nixos.system.stateVersion = "25.05";
    homeManager.home.stateVersion = "25.05";

    nixos = {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.android_sdk.accept_license = true;
      programs.nix-ld.enable = true;

      nix = {
        settings = {
          download-buffer-size = 262144000;
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://vicinae.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
          ];
        };
        gc = {
          automatic = false;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };
    };

    homeManager = {
      programs.home-manager.enable = true;
    };
  };

  den.ctx.hm-host.nixos.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
  };

  den.ctx.home = {
    instantiate =
      { pkgs, modules }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = { inherit inputs; };
      };
  };

  den.default.includes = [
    <vars>
    <den/define-user>
    <den/primary-user>

    (den.lib.take.exactly (
      { OS, host }:
      den.lib.take.unused OS {
        nixos.networking.hostName = host.hostName;
      }
    ))
  ];
}
