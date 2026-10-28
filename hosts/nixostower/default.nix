# default for desktop at appartment
{pkgs, ...}:

{
  imports = [
    ./hardware-configuration.nix 
    ../../modules/nixos 
  ];

  networking.hostName = "nixostower";

  #put the bootloader settings from generated conf on desktop 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #luks settings
  boot.initrd.luks.devices."luks-e0f933cb-bdf7-43fb-a324-939dc7b91232".device = "/dev/disk/by-uuid/e0f933cb-bdf7-43fb-a324-939dc7b91232";


  #loading graphics driver
  hardware.amdgpu.initrd.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  #tower specific packages
  home-manager.users.spyue = {pkgs, ...}: {
    imports = [../../modules/home];

    home.packages = with pkgs; [
      discord 
      prismlauncher

    ];
  };

  #add state version once initialized 
  system.stateVersion = "26.05";
}
