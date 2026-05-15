{ den, inputs, ... }:
{
  den.aspects.dev = {
    nixos =
      { pkgs, options, ... }:
      {
        environment.systemPackages = with pkgs; [
          uv
          dotnetCorePackages.dotnet_9.sdk
        ];
        programs.nix-ld = {
          enable = true;
          libraries =
            options.programs.nix-ld.libraries.default
            ++ (with pkgs; [
              dbus
              fontconfig
              freetype
              glib
              libGL
              libxkbcommon
              wayland
              stdenv.cc.cc
              zlib
              qt6.qtbase

              libX11
              libXcursor
              libxcb

              zstd
              curl
              openssl
              attr
              libssh
              bzip2
              libxml2
              acl
              libsodium
              util-linux
              xz
              systemd

              libXcomposite
              libXtst
              libXrandr
              libXext
              libXfixes
              libva
              pipewire
              xcb-util-cursor
              libXdamage
              libxshmfence
              libXxf86vm
              libelf

              gtk2

              networkmanager
              vulkan-loader
              libgbm
              libdrm
              libxcrypt
              coreutils
              pciutils
              zenity

              libXinerama
              libXrender
              libXScrnSaver
              libXi
              libSM
              libICE
              gnome2.GConf
              nspr
              nss
              cups
              libcap
              SDL2
              libusb1
              dbus-glib
              ffmpeg
              libudev0-shim

              gtk3
              icu
              libnotify
              gsettings-desktop-schemas

              libXt
              libXmu
              libogg
              libvorbis
              SDL
              SDL2_image
              glew_1_10
              libidn
              tbb

              flac
              freeglut
              libjpeg
              libpng
              libpng12
              libsamplerate
              libmikmod
              libtheora
              libtiff
              pixman
              speex
              SDL_image
              SDL_ttf
              SDL_mixer
              SDL2_ttf
              SDL2_mixer
              libappindicator-gtk2
              libdbusmenu-gtk2
              libindicator-gtk2
              libcaca
              libcanberra
              libgcrypt
              libvpx
              librsvg
              libXft
              libvdpau
              pango
              cairo
              atk
              gdk-pixbuf
              alsa-lib
              expat

              libxcrypt-legacy
              libGLU

              fuse
              e2fsprogs
            ]);
        };
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          bun
          love
          godot
          luajit
          gnumake
          just
          ninja
          pkg-config
          maven
          libXxf86vm
          dotnetCorePackages.sdk_9_0_1xx-bin
          devenv
          # inputs.devenv.packages.${pkgs.system}.devenv
          exercism
          python314
          typst
          devbox
        ];
        programs.java = {
          enable = true;
        };
      };
  };
}
