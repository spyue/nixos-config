#!/usr/bin/env bash
# Briefly switch the GTK theme and back, so running GTK apps reload their colors
dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3'"
sleep 0.2
dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3-dark'"
