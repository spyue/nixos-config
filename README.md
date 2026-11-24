# Spyue's NixOS Config

blah blah

screenshot of desktop

## Basic Outline

**Flake-based, multiple-hosts:** this repo builds all my machines with nearly everything shared between them (other than what I don't want shared) \
**Home Manager:** for packages and settings, as a nix module \
**live-linked dots:** dotfiles are linked to ~/.config so the edits apply without needing to rebuild \
**Dynamic theming by wallpaper:** a custom quickshell wallpaper picker runs matugen, upon selection apps such as hyprland, waybar, kitty, nvim, Firefox, Vesktop(discord), and more update their themes to match \
**Graphical boot and lock:** plymouth splash for luks password followed by auto login and auto put into hyprlock screen (temp solution until custom quickshell login sequence) \

## Current Machines

| Host          | Model                                        |
| ------------- | -------------------------------------------- |
| 'nixoslaptop' | Panasonic Lets Note cf-sv1                   |
| 'nixostower'  | Custom Gaming pc (Ryzen 5 5600x, RX 6650 XT) |

## File Structure

. \
|-- flake.nix \
| \
|-- hosts/ \
| |-- nixoslaptop/ \
| |-- nixostower/ \
| \
|-- modules/ \
| |-- nixos/ \
| |-- home/ \
| \
|-- dotfiles/
