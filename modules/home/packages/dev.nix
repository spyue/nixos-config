#programming stuff 
{pkgs, ...}:

{
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
  ];
}
