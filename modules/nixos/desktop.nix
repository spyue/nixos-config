{pkgs, ...}:

{
  #login screen (sddm on x11 for cursor)
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "spyue";
  };
  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.SAL_USE_VCLPLUGIN = "gtk3";

  security.polkit.enable = true;
  programs.dconf.enable = true; #lets GTK apps get cursor/theme settings

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  nerd-fonts.space-mono
  ];
}
