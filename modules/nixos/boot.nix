{ pkgs, ... }:

{
  boot.loader = {
    timeout = 3;                       # seconds before booting the newest generation
    systemd-boot = {
      configurationLimit = 10;         # keep the menu to the 10 newest generations
      consoleMode = "max";             # use the screen's highest resolution
      editor = false;                  # block editing boot entries from the menu
    };
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = [ pkgs.nixos-bgrt-plymouth ];
    };
    initrd.systemd.enable = true;        # lets Plymouth draw the disk password prompt
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [ "quiet" "splash" "udev.log_level=3" ];
  };
}
