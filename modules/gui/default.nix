{
  den,
  inputs,
  __findFile,
  ...
}:
{
  den.aspects.gui = {
    includes = [
      <gui/terminal>
      <gui/browser>
      <gui/libreoffice>
      <gui/games>
    ];
    homeManager =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        pkgsStable = import inputs.nixpkgs-stable {
          system = pkgs.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
        sftp = "${config.xdg.dataHome}/srv/sftp";
      in
      {
        programs = {
          vesktop = {
            enable = true;
          };

          imv.enable = true;
          zathura = {
            enable = true;

            mappings = {
              j = "scroll full-down";
              k = "scroll full-up";
              J = "scroll down";
              K = "scroll up";
            };
          };
        };
        home.file.".config/gtk-3.0/bookmarks".text = ''
          file://${config.xdg.userDirs.documents}/studia
          file://${config.xdg.userDirs.documents}
          file://${config.xdg.userDirs.download}
          file://${config.xdg.userDirs.pictures}
          file://${config.xdg.userDirs.music}
          file://${sftp}
        '';
        home.packages = with pkgs; [
          xdg-desktop-portal-gtk
          chromium
          gimp
          aseprite
          libresprite
          processing
          syncplay
          pear-desktop
          mpv
          audacious
          blender
          gparted
          krita
          renderdoc
          goxel

          shotcut
          kdePackages.kdenlive

          ardour
          supercollider
          foxdot
          chuck
          # miniaudicle
          antigravity

          qbittorrent-enhanced
          jackett
          qui

          easyeffects

          zed-editor
          parsec-bin
          kiro-cli
          kiro

          tracy
          vinegar
          neovide
        ];

        gtk = {
          enable = true;
          gtk4.theme = config.gtk.theme;
          iconTheme = {
            package = pkgs.nordzy-icon-theme;
            name = "Nordzy-dark";
          };
        };
      };
  };
}
