{
  inputs,
  den,
  pkgs,
  __findFile,
  ...
}:
{
  den.homes.x86_64-linux.kuba = { };

  den.aspects.kuba = {
    includes = [
      # CLI tools
      <cli>

      # TUI applications
      <tui>

      # GUI applications
      <gui>

      # Services
      <services>
    ];

    nixos =
      { config, pkgs, ... }:
      {
        programs.zsh.enable = true;

        users = {
          defaultUserShell = pkgs.zsh;
          groups."keyd".name = "keyd";
          users.kuba = {
            isNormalUser = true;
            description = "kuba account";
            extraGroups = [
              "networkmanager"
              "wheel"
              "keyd"
            ];
          };
        };
      };

    homeManager =
      { config, pkgs, ... }:
      {
        home = {
          username = "kuba";
          homeDirectory = "/home/kuba";
          stateVersion = "25.05";
        };
      };
  };
}
