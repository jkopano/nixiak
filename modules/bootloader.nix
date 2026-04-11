{ den, ... }:
{
  den.aspects.bootloader.nixos =
    { pkgs, lib, ... }:
    {
      boot = {
        plymouth = {
          enable = true;
          theme = lib.mkForce "rings";
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "rings" ];
            })
          ];
        };
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ];

        loader = {
          efi.canTouchEfiVariables = true;
          systemd-boot = {
            enable = true;
          };
        };
      };
    };
}
