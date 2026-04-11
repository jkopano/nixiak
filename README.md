# nixiak

Personal NixOS flake, built with `den` and Home Manager.

## Overview

At least for now flake only defines one machine with one user,
will definitely expand it in future.

- desktop: Niri on Wayland
- platform: `x86_64-linux`

## Usage

```sh
sudo nixos-rebuild switch --flake .#jkopano

# After initial switch you can make use of nh and write:
sw

# For updating
nix flake update
```

## Notes

- Home Manager is applied through the same flake
- this repo is machine-specific rather than a generic template - so i would
  not recommend to use it as is - rather take whatever snippet of code you wish.
