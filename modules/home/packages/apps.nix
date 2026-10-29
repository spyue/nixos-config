#normal apps I need
{pkgs, ...}:

{
  home.packages = with pkgs; [
    librewolf
    libreoffice
    hunspell
    hunspellDicts.en_US
    fastfetch
    kdePackages.kate
    pywalfox-native
  ];
}
