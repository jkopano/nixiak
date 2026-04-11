{ den, inputs, ... }:
{
  den.aspects.wayland._.vicinae.homeManager =
    { pkgs, lib, ... }:
    {
      programs.vicinae = {
        enable = true;
        systemd = {
          enable = true;
          autoStart = true;
        };

        settings = {
          close_on_focus_loss = true;
          pop_to_root_on_close = false;
          escape_key_behavior = "close_window";
          font = {
            normal = {
              size = 18;
              normal = "MapleMono Nerd Font";
            };
          };
          launcher_window = {
            opacity = lib.mkDefault 0.55;
            size = {
              width = 800;
              height = 900;
            };
          };
        };
        extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
          # bluetooth
          nix
          power-profile
          fuzzy-files
          firefox
          aria2-manager
          process-manager
          # pulseaudio
          otp
        ];
      };
    };
}
