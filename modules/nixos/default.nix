#settings shared by every machine 
{
  imports = [
    ./core.nix
    ./desktop.nix
    ./audio.nix 
    ./gaming.nix
    ./boot.nix
  ];
}

