setup_steam() {
    flatpak install -y flathub com.valvesoftware.Steam net.davidotek.pupgui2 \
        org.freedesktop.Platform.VulkanLayer.gamescope//25.08
    paru -S --noconfirm game-devices-udev
}

setup_heroic() {
    flatpak install -y flathub com.heroicgameslauncher.hgl
}

setup_lutris() {
    flatpak install -y flathub net.lutris.Lutris
}

setup_gaming() {
    setup_steam
    setup_heroic
    setup_lutris
}
