#links folders in ~/nixos-config/dotfiles into ~/.config 
#theyre live links (no need to rebuild) 
{config, ...}:

let 
  dots = "${config.home.homeDirectory}/nixos-config/dotfiles";
  link = name: config.lib.file.mkOutOfStoreSymlink "${dots}/${name}";
in 
{
  xdg.configFile = {
    "hypr".source = link "hypr";
    "kitty".source = link "kitty";
    "fastfetch".source = link "fastfetch";
    "nvim".source = link "nvim";
  };
}
