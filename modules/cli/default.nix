{
  den,
  inputs,
  __findFile,
  ...
}:
{
  den.aspects.cli = {
    includes = [
      <cli/scripts>
      <cli/starship>
      <cli/zsh>
      <cli/nushell>
    ];
    homeManager =
      { pkgs, ... }:
      {
        imports = [
          inputs.direnv-instant.homeModules.direnv-instant
        ];

        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;

        programs.bat = {
          enable = true;
          config = {
            # theme = "base16"; # Handled by stylix
          };
        };

        home.sessionVariables = {
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          MANROFFOPT = "-c";
        };
        home.packages = with pkgs; [
          imagemagick
          ffmpeg
          fzf
          ripgrep
          eza
          zoxide
          fd
          jq
          htop
          tldr
          tree
          unzip
          zip
          wget
          curl
          git
          lazygit
          nh
          nix-output-monitor
          nvd
          btop
          iotop
          iftop
          strace
          ltrace
          lsof
          sysstat
          lm_sensors
          ethtool
          pciutils
          usbutils
          vivid
          fastfetch
          onefetch
          cpufetch
          ramfetch
          graphviz
          with-shell
          dysk
          inxi
          nix-init
          comma
          nurl
        ];
      };
  };
}
