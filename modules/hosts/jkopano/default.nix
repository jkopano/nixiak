{
  inputs,
  den,
  __findFile,
  ...
}:
{
  den.aspects.jkopano = {
    includes = [
      <overlays>
      <base>
      <bootloader>
      <dev>
      <hardware>
      <session>
      <stylix>
      <wayland>
    ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4
          inputs.xremap-flake.nixosModules.default
        ];

        # Hardware configuration (ThinkPad T14s AMD Gen4)
        hardware.enableRedistributableFirmware = lib.mkDefault true;
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        boot = {
          initrd.availableKernelModules = [
            "nvme"
            "xhci_pci"
            "usb_storage"
            "sd_mod"
            "sdhci_pci"
          ];
          initrd.kernelModules = [ "amdgpu" ];
          kernelModules = [ "kvm-amd" ];
          extraModulePackages = [ ];
        };

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/c9d4e798-0b36-4ff6-888e-98532fed868e";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/9E05-5BE9";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [
          { device = "/dev/disk/by-uuid/12590a3f-8eb2-4f63-bf5b-6d525a40e6ef"; }
        ];

        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

        # Host-specific settings
        networking.hostName = "jkopano";

        time.timeZone = "Europe/Warsaw";
        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocaleSettings = {
            LC_ADDRESS = "pl_PL.UTF-8";
            LC_IDENTIFICATION = "pl_PL.UTF-8";
            LC_MEASUREMENT = "pl_PL.UTF-8";
            LC_MONETARY = "pl_PL.UTF-8";
            LC_NAME = "pl_PL.UTF-8";
            LC_NUMERIC = "pl_PL.UTF-8";
            LC_PAPER = "pl_PL.UTF-8";
            LC_TELEPHONE = "pl_PL.UTF-8";
            LC_TIME = "pl_PL.UTF-8";
          };
        };

        system.stateVersion = "25.05";
      };
  };
}
