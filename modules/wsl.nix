{ inputs, self, ... }:
let
  system = "x86_64-linux";
  common = {
    imports = [ inputs.nixos-wsl.nixosModules.default ];
    wsl.enable = true;
    wsl.defaultUser = "kuba";
    networking.hostName = "wsl";
    nixpkgs.hostPlatform = system;

    system.stateVersion = "26.05";

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    users.users.kuba = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
in
{
  flake.nixosConfigurations = {
    wsl-bootstrap = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ common ];
    };

    wsl = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        common
        inputs.home-manager.nixosModules.home-manager
        ../hosts/wsl/system.nix
      ];
    };
  };

  flake.deploy.nodes.wsl = {
    hostname = "windows-wsl";
    sshUser = "kuba";
    sshOpts = [
      "-p"
      "2222"
    ];
    autoRollback = true;
    magicRollback = true;
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.wsl;
    };
  };

  perSystem = { system, ... }: {
    packages.deploy = inputs.deploy-rs.packages.${system}.default;
    checks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
  };
}
