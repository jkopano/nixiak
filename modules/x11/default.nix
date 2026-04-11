# X11 desktop module - converted to den aspects
{ den, inputs, __findFile, ... }:
{
  den.aspects.x11 = {
    includes = [
      <x11/i3>
      <x11/dunst>
      <x11/rofi>
      <x11/picom>
      <x11/wal>
    ];
    nixos =
      { pkgs, ... }:
      {
        services = {
          xserver = {
            enable = true;
            windowManager.i3.enable = true;
            videoDrivers = [ "amdgpu" ];
          };
          autorandr = {
            enable = true;
            profiles = {
              "main" = {
                fingerprint = {
                  "eDP-1" =
                    "00ffffffffffff0009e5d60800000000251d0104a51f1178031ef5965d5b91291c505400000001010101010101010101010101010101c0398018713828403020360035ae1000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e34550a0011";
                };
                config = {
                  "eDP-1" = {
                    enable = true;
                    mode = "1920x1080";
                    position = "0x0";
                    primary = true;
                    rotate = "normal";
                  };
                };
              };
              "default" = {
                fingerprint = {
                  "DP-3" =
                    "00ffffffffffff0038a3d76801010101051a010380342078ea4ca5a7554da22610505423080081008140818081c095009040b300d100283c80a070b023403020360007442100001a000000fd00383d1f4d11000a202020202020000000fc004541323434574d690a20202020000000ff0036323030343135384e420a2020014e020317f14400040103230907078301000065030c001000011d007251d01e206e28550007442100001e8c0ad08a20e02d10103e960007442100001800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006c";
                  "DP-4" =
                    "00ffffffffffff000469ab2401010101091d010380342078ea0d45a556539d250e5054230800818081409500a940b300d1c001010101283c80a070b023403020360006442100001a000000fd00323d1e5310000a202020202020000000fc0042453234410a20202020202020000000ff004b334c4d51533030333531330a00d2";
                };
                config = {
                  "DP-4" = {
                    enable = true;
                    mode = "1920x1200";
                    rotate = "left";
                    position = "0x0";
                  };
                  "DP-3" = {
                    enable = true;
                    mode = "1920x1200";
                    rotate = "normal";
                    position = "1200x500";
                    primary = true;
                  };
                };
              };
              "desktop" = {
                fingerprint = {
                  "DP-3" =
                    "00ffffffffffff0038a3d76801010101051a010380342078ea4ca5a7554da22610505423080081008140818081c095009040b300d100283c80a070b023403020360007442100001a000000fd00383d1f4d11000a202020202020000000fc004541323434574d690a20202020000000ff0036323030343135384e420a2020014e020317f14400040103230907078301000065030c001000011d007251d01e206e28550007442100001e8c0ad08a20e02d10103e960007442100001800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006c";
                  "DP-4" =
                    "00ffffffffffff000469ab2401010101091d010380342078ea0d45a556539d250e5054230800818081409500a940b300d1c001010101283c80a070b023403020360006442100001a000000fd00323d1e5310000a202020202020000000fc0042453234410a20202020202020000000ff004b334c4d51533030333531330a00d2";
                  "eDP-1" =
                    "00ffffffffffff0009e5d60800000000251d0104a51f1178031ef5965d5b91291c505400000001010101010101010101010101010101c0398018713828403020360035ae1000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e34550a0011";
                };
                config = {
                  "DP-4" = {
                    enable = true;
                    mode = "1920x1200";
                    rotate = "left";
                    position = "0x0";
                  };
                  "DP-3" = {
                    enable = true;
                    mode = "1920x1200";
                    rotate = "normal";
                    position = "1200x720"; # or "1200x0" to align top edges
                  };
                  "eDP-1" = {
                    enable = true;
                    mode = "1920x1080";
                    position = "268x1920";
                    primary = true;
                    rotate = "normal";
                  };
                };
              };
            };
            hooks.postswitch = # sh
              {
                "notify-i3" = "${pkgs.i3}/bin/i3-msg restart";
              };
          };
          udev.extraRules = ''ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr -c"'';
        };
      };
    homeManager =
      { pkgs, lib, ... }:
      {
        home.packages = with pkgs; [
          pavucontrol
          gpick
        ];

        xsession.initExtra = ''
          systemctl --user start graphical-session.target
          ${lib.getExe pkgs.xset} r rate 200 40
        '';
      };
  };
}
