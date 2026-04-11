{
  den,
  inputs,
  __findFile,
  ...
}:
{
  den.aspects.wayland = {
    includes = [
      # <wayland/gnome>
      <wayland/niri>
      <wayland/kanshi>
    ];
    nixos =
      { pkgs, ... }:
      {
        services = {
          desktopManager = {
            gnome.enable = true;
            plasma6.enable = false;
          };
        };

        programs.niri.enable = true;
        programs.xwayland.enable = true;

        environment.gnome.excludePackages = with pkgs; [
          totem
          gnome-console
          epiphany
          foot
          gedit
          gnome-tour
          papers
        ];
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          libwacom
          anyrun
          wofi
          fuzzel
          wluma
          celeste

          wl-color-picker
          wl-clipboard
          qrencode
          warp

          gnomecast
        ];
      };
  };
}
