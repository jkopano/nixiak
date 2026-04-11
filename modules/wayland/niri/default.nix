{
  den,
  inputs,
  lib,
  __findFile,
  ...
}:
{
  den.aspects.wayland._.niri = {
    includes = [
      <wayland/niri/settings>
      <wayland/niri/binds>
      <wayland/niri/theme>
      <wayland/noctalia>
      <wayland/vicinae>
      <wayland/shikane>
    ];
    homeManager =
      {
        pkgs,
        ...
      }:
      {
        imports = [
          {
            key = "niri-flake-module-dedup";
            imports = [ inputs.niri.homeModules.niri ];
          }
        ];
        programs.niri = {
          enable = true;
          package = lib.mkForce inputs.niri.packages.${pkgs.system}.niri-unstable;
        };

        home = {
          packages = with pkgs; [
            seatd
            jaq
            xwayland-satellite
            wdisplays
          ];
        };
      };
  };

  # nixos =
  #   { pkgs, ... }:
  #   {
  #     programs.niri.enable = true;
  #     programs.niri.package = pkgs.lib.mkForce inputs.niri.packages.${pkgs.system}.niri-unstable;
  #   };
}
