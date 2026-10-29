{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  # Tells apps and websites you prefer dark mode
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "adw-gtk3-dark";
  };

  # Makes sure LibreOffice uses GTK (so it follows these colors)
  home.sessionVariables.SAL_USE_VCLPLUGIN = "gtk3";
}
