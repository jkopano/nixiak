{
  description = "NixOS configuration using den";

  inputs = {
    # Den ecosystem
    den.url = "github:vic/den/8acd14aeb4ab836fdc2abd431d2cd710905084c5";
    flake-parts.url = "github:hercules-ci/flake-parts/f20dc5d9b8027381c474144ecabc9034d6a839a3";
    flake-aspects.url = "github:vic/flake-aspects/ccc25fc1e06b8957e15e6d0c0a0c51e9d7a96b37";
    import-tree.url = "github:vic/import-tree/10fda59eee7d7970ec443b925f32a1bc7526648c";

    # Core
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming
    stylix.url = "github:danth/stylix";

    # Applications
    firefox-addons.url = "github:osipog/nix-firefox-addons";
    nixcord.url = "github:kaylorben/nixcord";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Tools
    xremap-flake.url = "github:xremap/nix-flake";
    nix-sweep.url = "github:jzbor/nix-sweep";
    direnv-instant.url = "github:Mic92/direnv-instant";

    # Desktop
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware
    scroll-flake = {
      url = "github:AsahiRocks/scroll-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
