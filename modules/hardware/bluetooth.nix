{ den, ... }:
{
  den.aspects.hardware._.bluetooth = {
    nixos =
      { ... }:
      {
        hardware.bluetooth = {
          enable = true;
          settings = {
            General = {
              MultiProfile = "multiple";
              FastConnectable = true;
            };
          };
          powerOnBoot = true;
        };
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ bluetui ];
      };
  };
}
