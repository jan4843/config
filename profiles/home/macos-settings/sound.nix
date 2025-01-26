{
  self.scripts.write.darwin-settings-sound = {
    path = [ "darwin" ];
    text = ''
      nvram StartupMute 2>/dev/null | grep -q %01 ||
      sudo nvram StartupMute=%01
    '';
  };
}
