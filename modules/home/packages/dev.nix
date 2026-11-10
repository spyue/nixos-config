#programming stuff 
{pkgs, ...}:

{
  programs.java.enable = true;

  home.packages = with pkgs; [
    gcc 
    gnumake
    ripgrep
    fd
    fzf 
    lazygit 
    unzip 
    nodejs
    nixd
    jdk
    dnsutils

    (python3.withPackages (ps: with ps; [
      matplotlib
      numpy
      mss
      pillow
      pytesseract
    ])) 

    #game dev
    godot
  ];
}
