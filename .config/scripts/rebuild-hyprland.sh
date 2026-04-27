#!/usr/bin/bash

NO_CONFIRM_FLAGS=(--rebuild --answerdiff None --answerclean None --answeredit None --noconfirm)

yay -S hyprutils-git hyprwayland-scanner-git "${NO_CONFIRM_FLAGS[@]}"
yay -S aquamarine-git hyprgraphics-git hyprlang-git "${NO_CONFIRM_FLAGS[@]}"
yay -S hyprtoolkit-git "${NO_CONFIRM_FLAGS[@]}"
yay -S hyprcursor-git hyprgraphics-git hyprland-guiutils-git hyprwire-git "${NO_CONFIRM_FLAGS[@]}"
yay -S hyprland-git "${NO_CONFIRM_FLAGS[@]}"
yay -S hyprlauncher-git hyprlock-git hyprpaper-git hyprpolkitagent-git hyprshutdown-git hyprsysteminfo-git xdg-desktop-portal-hyprland-git "${NO_CONFIRM_FLAGS[@]}"
