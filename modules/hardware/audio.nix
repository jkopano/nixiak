{ den, ... }:
{
  den.aspects.hardware._.audio.nixos =
    { ... }:
    {
      security.rtkit.enable = true;
      services.pulseaudio.enable = false;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber = {
          enable = true;
          extraConfig = {
            "10-disable-camera" = {
              "wireplumber.profiles" = {
                main."monitor.libcamera" = "disabled";
              };
            };
          };
        };

        extraConfig.pipewire = {
          "99-disable-bell" = {
            "context.properties" = {
              "module.x11.bell" = false;
            };
          };
        };
      };
    };
}
