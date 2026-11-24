#video viewing/making/audio all that
{pkgs, ...}:

{
  home.packages = with pkgs; [
    lmms 
    vlc 
    musikcube
    kid3
    ani-cli
    krita

  #music
    ffmpeg
    yt-dlp
  ];
}
