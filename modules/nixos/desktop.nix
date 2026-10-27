{pkgs, ...}:

{
  #login screen (sddm on x11 for cursor)
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.sddm.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.polkit.enable = true;
  programs.dconf.enable = true; #lets GTK apps get cursor/theme settings

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  ];
}
