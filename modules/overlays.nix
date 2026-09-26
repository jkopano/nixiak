{
  inputs,
  den,
  ...
}:
{
  den.aspects.overlays.nixos =
    { ... }:
    {
      nixpkgs.overlays = [
        # NUR
        inputs.nur.overlays.default

        # Firefox addons
        inputs.firefox-addons.overlays.default

        # Wireplumber fix: https://github.com/NixOS/nixpkgs/issues/475202
        # (_final: prev: {
        #   wireplumber = prev.wireplumber.overrideAttrs (_old: rec {
        #     version = "0.5.12";
        #     src = prev.fetchFromGitLab {
        #       domain = "gitlab.freedesktop.org";
        #       owner = "pipewire";
        #       repo = "wireplumber";
        #       rev = version;
        #       hash = "sha256-3LdERBiPXal+OF7tgguJcVXrqycBSmD3psFzn4z5krY=";
        #     };
        #   });
        # })

        (_final: prev: {
          aseprite = prev.aseprite.overrideAttrs (old: rec {
            version = "1.3.17.2";
            src = prev.fetchFromGitHub {
              owner = "aseprite";
              repo = "aseprite";
              tag = "v${version}";
              fetchSubmodules = true;
              hash = "sha256-+rLrk/c3WLqNhXQ7J0eeqZ3h4PsbZad61Cxw0RubWgk=";
            };
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.git ];
          });

          gtksourceview5 = prev.gtksourceview5.overrideAttrs (_old: {
            doCheck = false;
          });

          pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
            (python-final: python-prev: {
              paste = python-prev.paste.overridePythonAttrs (old: {
                nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ [
                  python-final.setuptools
                ];
              });
            })
          ];
        })

        # inputs.neovim-nightly-overlay.overlays.default
      ];
    };
}
