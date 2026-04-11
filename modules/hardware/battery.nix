{ den, ... }:
{
  den.aspects.hardware._.battery.nixos =
    { pkgs, config, ... }:
    {
      powerManagement.enable = true;
      services = {
        upower.enable = true;
      };

      hardware.i2c.enable = true;
      boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
      boot.kernelModules = [ "ddcci_backlight" ];
      environment.systemPackages = with pkgs; [
        ddcutil
        brightnessctl
        tlp
      ];

      systemd.services."ddcci@" = {
        scriptArgs = "%i";
        script = ''
          echo Trying to attach ddcci to $1
          id=$(echo $1 | cut -d "-" -f 2)
          counter=5
          while [ $counter -gt 0 ]; do
            if ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b $id; then
              echo ddcci-dependent 0x37 > /sys/bus/i2c/devices/$1/new_device
              echo Successfully attached ddcci to $1
              break
            fi
            sleep 1
            counter=$((counter - 1))
          done
        '';
        serviceConfig.Type = "oneshot";
      };
    };
}
