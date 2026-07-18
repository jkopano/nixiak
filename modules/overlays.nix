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
          gtksourceview5 = prev.gtksourceview5.overrideAttrs (_old: {
            doCheck = false;
          });

          pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
            (
              python-final: python-prev: {
                paste = python-prev.paste.overridePythonAttrs (old: {
                  nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ [
                    python-final.setuptools
                  ];
                });
              }
            )
          ];
        })

        inputs.niri.overlays.niri
        # inputs.neovim-nightly-overlay.overlays.default
      ];
    };
}
