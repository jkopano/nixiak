{
  pkgs,
  lib,
  config,
  ...
}:
let
  rofi = lib.getExe pkgs.rofi;
  keepassxc = lib.getExe pkgs.keepassxc;
  tailscale = lib.getExe pkgs.tailscale;
in
pkgs.writeShellScriptBin "keepassxc-dmenu"
  # bash
  ''
    # KEYDT => file path to the keepassxc database
    # KEYFILE => key file path

    set +e

    if ! ${tailscale} ping -c 1 --icmp --until-direct=false kopan-alpine; then
      exit 1
    fi

    pidof keepassxc | xargs kill -9 || true

    prompt="PASSWORD FOR DATABASE: $KEEPASSXCDT"

    ${rofi} -dmenu -password -p "$prompt" -l 1 | ${keepassxc} --pw-stdin ${config.var.KEEPASSXCDT} --keyfile ${config.var.KEEPASSXCFILE} &
  ''
