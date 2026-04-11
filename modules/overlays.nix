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

        inputs.niri.overlays.niri
        # inputs.neovim-nightly-overlay.overlays.default
      ];
    };
}
