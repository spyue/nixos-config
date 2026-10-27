#Bash: prompt, fastfetch, and aliases (replaces ~/.bashrc)
{
  programs.bash = {
    enable = true;

    shellAliases = {
    #nix commands
      #rebuilds the current machine (if hostname matches flake.nix)
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/";
      #pull newest packages and rebuild (updates current machine)
      update = "nix flake update --flake ~/nixos-config && sudo nixos-rebuild switch --flake ~/nixos-config/";

    #audio commands
      #mutes system
      mute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      #setvolume use = setVol x%
      setVol = "wpctl set-volume @DEFAULT_AUDIO_SINK@";
      #checks volume 
      checkVol = "wpctl get-volume @DEFAULT_AUDIO_SINK@";
    };

    #ps1 line. controls how the prompt line looks in terminal
    initExtra = ''
      PS1='\[\e[38;2;137;186;122m\]\u@\h\[\e[38;5;137m\]:\[\e[1;38;5;173m\]\w\[\e[0m\] \[\e[38;5;179m\]\$\[\e[0m\] '
      fastfetch
    '';
  };
}
