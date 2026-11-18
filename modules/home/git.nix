#git identity
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user = {
      name = "spyue";
      email = "183024207+spyue@users.noreply.github.com";
    };
  };
}
