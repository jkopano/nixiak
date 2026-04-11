{ den, ... }:
{
  den.aspects.base.nixos =
    { pkgs, config, ... }:
    {
      systemd.services.NetworkManager-wait-online.enable = false;
      networking = {
        networkmanager.enable = true;
      };

      system.autoUpgrade = {
        enable = false;
        dates = "04:00";
        flake = config.var.configDir;
        flags = [
          "--update-input"
          "nixpkgs"
          "--commit-lock-file"
        ];
        allowReboot = true;
      };

      services.openssh.enable = true;

      environment = {
        systemPackages = with pkgs; [
          wget
          curl
          vim
          git
          jq
          ltrace
          strace
          acpi
          lsof
          lm_sensors
          pciutils
          usbutils
          nix-output-monitor
          which
          file
          nmap
          xz
          p7zip
          unzip
          zip
          fuse3
          xhost
          niv
          age
          sops
        ];
        variables = {
          EDITOR = "nvim";
          SUDO_EDITOR = "nvim";
          BROWSER = "firefox";
          TERMINAL = "kitty";
          TMUX_SESSION_FILE = "${config.var.configDir}/modules/tui/tmux/tmux_sessions";
          SSH_ASKPASS_REQUIRE = "prefer";
          XDG_RUNTIME_DIR = "/run/user/$UID";
        };
      };
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "*";
      };

      hardware.uinput.enable = true;
      boot.kernelModules = [ "uinput" ];
      users.users.kuba.extraGroups = [
        "video"
        "audio"
      ];

      security.sudo.wheelNeedsPassword = false;
    };
}
