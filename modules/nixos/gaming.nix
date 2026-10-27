#gaming stuff
{pkgs, ...}:

{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  users.users.spyue.extraGroups = ["gamemode"];

  environment.systemPackages = with pkgs; [
    mangohud
  ];
}
