# default for desktop at appartment
{pkgs, ...}:

{
  imports = [
    ./hardware-configuration.nix 
    ../../modules/nixos 
  ];

  networking.hostname = "nixostower";

  #put the bootloader settings from generated conf on desktop 


  #loading graphics driver
  hardware.amdgpu.initrd.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  #tower specific packages
  home-manager.users.users.spyue = {pkgs, ...}: {
    imports = [../../modules/home];

    home.packages = with pkgs; [
      discord 

    ];
  };

  #add state version once initialized 
  #system.stateVersion = "";
}
