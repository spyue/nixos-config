{pkgs, ...}:

{
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Halifax";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.spyue = {
    isNormalUser = true;
    description = "spyue";
    extraGroups = ["networkmanager" "wheel" "wireshark"];
  };

  boot.extraModprobeConfig = ''
    options iwlmvm power_scheme=1
  '';

  #enables printing (CUPS)
  services.printing.enable = true;

  #tailscale
  services.tailscale.enable = true;

  #system wide nvim (sudo)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  #localsend 
  programs.localsend = {
    enable = true; 
    openFirewall = true; 
  };

  #wireshark
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  #allows downloading of binaries like mason in lazy or pip 
  programs.nix-ld.enable = true;

  programs.ssh.startAgent = true;

  #minimal for root and recovery, everything else in home-manager
  environment.systemPackages = with pkgs; [
    git 
    wget 
    curl 
  ];
}
