#user setup shared between machines
{
  imports =[
    ./packages/desktop.nix
    ./packages/apps.nix
    ./packages/dev.nix
    ./packages/school.nix
    ./packages/media.nix
    ./shell.nix
    ./git.nix
    ./dotfiles.nix
    ./theme.nix
  ];

  home.username = "spyue";
  home.homeDirectory = "/home/spyue";

  #home manager version I started with (do not change)
  home.stateVersion = "26.05";
}
