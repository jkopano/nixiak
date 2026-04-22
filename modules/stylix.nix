{
  den,
  inputs,
  ...
}:
{
  den.aspects.stylix = {
    nixos =
      { pkgs, config, ... }:
      {
        imports = [ inputs.stylix.nixosModules.stylix ];

        stylix = {
          enable = true;
          # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-pale.yaml";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

          override = {
            base00 = "131313";
            base01 = "1d2021";
          };

          cursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Ice";
            size = 24;
          };
          fonts = {
            monospace = {
              package = pkgs.nerd-fonts.jetbrains-mono;
              name = "JetBrains Mono";
            };
            sansSerif = {
              package = pkgs.montserrat;
              name = "Maple Mono";
            };
            serif = {
              package = pkgs.montserrat;
              name = "Maple Mono";
            };
            sizes = {
              applications = 12;
              terminal = 15;
              desktop = 13;
              popups = 12;
            };
          };
        };
      };
    homeManager =
      { pkgs, lib, ... }:
      {
        stylix.override = {
          base00 = "131313";
          base01 = "1d2021";
        };
        home.packages = with pkgs; [
          jetbrains-mono
          maple-mono.truetype
          nerd-fonts.jetbrains-mono
          nerd-fonts.ubuntu-mono
          nerd-fonts.iosevka
          nerd-fonts.zed-mono
          nerd-fonts.fantasque-sans-mono
          nerd-fonts.agave
          nerd-fonts.caskaydia-mono
          fantasque-sans-mono
        ];
        stylix.targets = {
          noctalia-shell.enable = lib.mkForce true;
          tmux.enable = false;
          kde.enable = true;
          rofi.enable = true;
          ghostty.enable = true;
          btop.enable = true;
          helix.enable = true;
          sway.enable = true;
          qt = {
            enable = true;
            platform = "qtct";
          };
          nvf.enable = false;
          neovim.enable = lib.mkForce false;
          i3.enable = true;
          fzf.enable = true;
          hyprland.enable = false;
          yazi.enable = false;
          firefox = {
            enable = true;
            profileNames = [ "default" ];
          };
        };
      };
  };
}
