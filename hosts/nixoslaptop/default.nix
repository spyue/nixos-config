{pkgs, ...}:

{
  imports = [
    ./hardware-configuration.nix 
    ../../modules/nixos
  ];

  #has to match in flake.nix
  networking.hostName = "nixoslaptop"; 
  
  #bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #encrypted disk for this laptop (do not try to copy just rewrite)
  boot.initrd.luks.devices."luks-a2d85662-58ab-4c99-b064-974d321f130e".device = "/dev/disk/by-uuid/a2d85662-58ab-4c99-b064-974d321f130e";


  #laptop specific pkgs and settings
  home-manager.users.spyue = {pkgs, ...}: {
      imports = [../../modules/home];

      home.packages = with pkgs; [
      #any laptop specific packages go here 


      ];
  };

  #value from this machines initial install (never change) 
  system.stateVersion = "26.05";
}
