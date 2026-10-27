#hyprland tools
{pkgs, ...}:

{
  home.packages = with pkgs; [
    kitty 
    wofi 
    waybar
    mako 
    hyprpaper
    hyprlock
    hypridle
    hyprpolkitagent
    grim
    slurp
    wl-clipboard
    networkmanagerapplet
    pavucontrol
    kdePackages.dolphin
    bibata-cursors
  ];
}
