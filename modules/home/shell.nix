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
      PS1='\[\e[34m\]\u@\h\[\e[90m\]:\[\e[1;35m\]\w\[\e[0m\] \[\e[36m\]\$\[\e[0m\] '

      fastfetch() {
        local cover
        cover=$(shopt -s nullglob; printf '%s\n' ~/Music/vault/albums/*/[Cc]over.{png,jpg} | shuf -n 1)
        if [ -f "$cover" ] && [ "$TERM" = "xterm-kitty" ]; then
          command fastfetch --logo "$cover" --logo-type kitty --logo-height 15 --logo-preserve-aspect-ratio true "$@"
        else
          command fastfetch "$@"
        fi
      }
      fastfetch 
        '';
  };
}
